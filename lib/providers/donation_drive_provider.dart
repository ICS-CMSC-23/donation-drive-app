import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/organization_model.dart';
import 'organization_provider.dart';
import 'auth_provider.dart';
import '../models/donation_drive_model.dart';
import '../api/firebase_donation_drive_api.dart';

class DonationDriveListProvider with ChangeNotifier {
  final FirebaseDonationDriveAPI firebaseService = FirebaseDonationDriveAPI();
  late Stream<QuerySnapshot> _donationDriveStream;
  int _donationDriveCount = 0;
  List<DonationDrive> _allDonationDrives = [];
  List<DonationDrive> _filteredDonationDrives = [];
  MyAuthProvider authProvider;
  OrganizationListProvider organizationListProvider;

  DonationDriveListProvider(
      {required this.authProvider, required this.organizationListProvider}) {
    fetchDonationDrives();
  }

  List<DonationDrive> get donationDrives => _filteredDonationDrives;

  int get donationDriveCount => _donationDriveCount;

  Future<void> fetchDonationDrives() async {
    String email = authProvider.userObj!.email!;
    Organization? organization =
        await organizationListProvider.getOrganizationByUsername(email);
    print(email);
    print(organization?.id);
    _donationDriveStream =
        firebaseService.getDonationDrivesByOrganizationId(organization?.id);
    _donationDriveStream.listen((snapshot) {
      _allDonationDrives = snapshot.docs
          .map((doc) =>
              DonationDrive.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      _filteredDonationDrives = List.from(_allDonationDrives);
      _donationDriveCount = _filteredDonationDrives.length;
      notifyListeners();
    });
  }

  Future<String?> getOrganizationIdByEmail(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('organizations')
        .where('username', isEqualTo: email)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      return result.docs.first.id;
    }
    return null;
  }

  void addDonationDrive(DonationDrive donationDrive) async {
    String message =
        await firebaseService.addDonationDrive(donationDrive.toJson());
    print(message);
    fetchDonationDrives();
  }

  void editDonationDrive(DonationDrive donationDrive) async {
    String message = await firebaseService.editDonationDrive(
        donationDrive.id!, donationDrive.toJson());
    print(message);
    fetchDonationDrives();
  }

  void deleteDonationDrive(String id) async {
    String message = await firebaseService.deleteDonationDrive(id);
    print(message);
    fetchDonationDrives();
  }

  void searchDonationDrives(String query) {
    if (query.isEmpty) {
      _filteredDonationDrives = List.from(_allDonationDrives);
    } else {
      _filteredDonationDrives = _allDonationDrives.where((drive) {
        return drive.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    _donationDriveCount = _filteredDonationDrives.length;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/donation_drive_model.dart';
import '../api/firebase_donation_drive_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationDriveListProvider with ChangeNotifier {
  late FirebaseDonationDriveAPI firebaseService;
  late Stream<QuerySnapshot> _donationDriveStream;
  int _donationDriveCount = 0;

  DonationDriveListProvider() {
    firebaseService = FirebaseDonationDriveAPI();
    fetchDonationDrives();
  }

  Stream<QuerySnapshot> get donationDrives => _donationDriveStream;

  int get donationDriveCount => _donationDriveCount;

  fetchDonationDrives() {
    _donationDriveStream = firebaseService.getAllDonationDrives();
    _donationDriveStream.listen((snapshot) {
      _donationDriveCount = snapshot.docs.length;
      notifyListeners();
    });
  }

  Future<int> getDonationDriveCount() async {
    QuerySnapshot snapshot = await firebaseService.getAllDonationDrives().first;
    return snapshot.docs.length;
  }

  void addDonationDrive(DonationDrive donationDrive) async {
    String message =
        await firebaseService.addDonationDrive(donationDrive.toJson());
    print(message);
    notifyListeners();
  }

  void editDonationDrive() {
    // TODO: fill edit donation drive
  }

  void deleteDonationDrive() {
    // TODO: fill delete donation drive
  }
}

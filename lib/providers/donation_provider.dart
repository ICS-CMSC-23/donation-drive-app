import 'package:flutter/material.dart';
import '../models/donation_model.dart';
import '../api/firebase_donation_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationListProvider with ChangeNotifier {
  late FirebaseDonationAPI firebaseService;
  late Stream<QuerySnapshot> _donationStream;
  int _donationCount = 0;

  DonationListProvider() {
    firebaseService = FirebaseDonationAPI();
    fetchDonation();
  }

  Stream<QuerySnapshot> get donations => _donationStream;

  int get donationCount => _donationCount;

  fetchDonation() {
    _donationStream = firebaseService.getAllDonations();
    _donationStream.listen((snapshot) {
      _donationCount = snapshot.docs.length;
      notifyListeners();
    });
  }

  Future<int> getDonationCount() async {
    QuerySnapshot snapshot = await firebaseService.getAllDonations().first;
    return snapshot.docs.length;
  }

  void addDonation(Donation donation) async {
    String message =
        await firebaseService.addDonation(donation.toJson() as Donation);
    print(message);
    notifyListeners();
  }

  void editDonation(String id, Map<String, dynamic> data) async {
    String message = await firebaseService.editDonation(id, data);
    print(message);
    notifyListeners();
  }

  void deleteDonation(String id) async {
    String message = await firebaseService.deleteDonation(id);
    print(message);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/donor_model.dart';
import '../api/firebase_donor_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorListProvider with ChangeNotifier {
  late FirebaseDonorAPI firebaseService;
  late Stream<QuerySnapshot> _donorStream;
  int _donorCount = 0;

  DonorListProvider() {
    firebaseService = FirebaseDonorAPI();
    fetchDonors();
  }

  Stream<QuerySnapshot> get donors => _donorStream;

  int get donorCount => _donorCount;

  fetchDonors() {
    _donorStream = firebaseService.getAllDonors();
    _donorStream.listen((snapshot) {
      _donorCount = snapshot.docs.length;
      notifyListeners();
    });
  }

  Future<int> getDonorCount() async {
    QuerySnapshot snapshot = await firebaseService.getAllDonors().first;
    return snapshot.docs.length;
  }

  void addDonor(Donor donor) async {
    String message = await firebaseService.addDonor(donor.toJson());
    print(message);
    notifyListeners();
  }

  void editDonor() {
    // TODO: fill edit donor
  }

  void deleteDonor() {
    // TODO: fill delete donor
  }
}

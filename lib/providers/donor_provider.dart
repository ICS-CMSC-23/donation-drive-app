import 'package:flutter/material.dart';
import '../models/donor_model.dart';
import '../api/firebase_donor_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorListProvider with ChangeNotifier {
  late FirebaseDonorAPI firebaseService;
  late Stream<QuerySnapshot> _donorStream;

  DonorListProvider() {
    firebaseService = FirebaseDonorAPI();
    fetchDonors();
  }

  Stream<QuerySnapshot> get donors => _donorStream;

  fetchDonors() {
    _donorStream = firebaseService.getAllDonors();
    notifyListeners();
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

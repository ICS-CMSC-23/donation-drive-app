import 'package:flutter/material.dart';
import '../models/organization_model.dart';
import '../api/firebase_organization_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationListProvider with ChangeNotifier {
  late FirebaseOrganizationAPI firebaseService;
  late Stream<QuerySnapshot> _organizationStream;
  int _organizationCount = 0;

  OrganizationListProvider() {
    firebaseService = FirebaseOrganizationAPI();
    fetchOrganizations();
  }

  Stream<QuerySnapshot> get organizations => _organizationStream;

  int get organizationCount => _organizationCount;

  fetchOrganizations() {
    _organizationStream = firebaseService.getAllOrganizations();
    _organizationStream.listen((snapshot) {
      _organizationCount = snapshot.docs.length;
      notifyListeners();
    });
  }

  Future<int> getOrganizationCount() async {
    QuerySnapshot snapshot = await firebaseService.getAllOrganizations().first;
    return snapshot.docs.length;
  }

  void addOrganization(Organization organization) async {
    String message =
        await firebaseService.addOrganization(organization.toJson());
    print(message);
    notifyListeners();
  }

  void editOrganization() {
    // TODO: fill edit donor
  }

  void deleteOrganization() {
    // TODO: fill delete donor
  }
}

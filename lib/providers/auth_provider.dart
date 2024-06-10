import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  User? userObj;

  MyAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
    listenToAuthChanges();
  }

  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();
    notifyListeners();
  }

  void listenToAuthChanges() {
    uStream.listen((user) {
      userObj = user;
      notifyListeners();
    });
  }

  Future<String?> signUp(String email, String password) async {
    String? result = await authService.signUp(email, password);
    notifyListeners();
    return result;
  }

  Future<String?> signIn(String email, String password) async {
    String? result = await authService.signIn(email, password);
    print(result);
    if (result == "Sign in successful") {
      userObj = FirebaseAuth.instance.currentUser;

      bool isDonor = await checkIfDonor(email);
      bool isOrganization = await checkIfOrganization(email);
      if (email == "admin@gmail.com" && password == "admin12345") {
        result = "admin";
      } else if (isDonor) {
        result = "donor";
      } else if (isOrganization) {
        result = "organization";
      } else {
        result = "User type unknown";
      }
    }
    notifyListeners();
    return result;
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }

  Future<bool> checkIfDonor(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('donors')
        .where('username', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<bool> checkIfOrganization(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('organizations')
        .where('username', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }
}

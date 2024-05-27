import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Map<String, dynamic> donation) async {
    try {
      await db.collection('donations').add(donation);
      return "Successfully added donation!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonations() {
    print(db.collection("donations").snapshots());
    return db.collection("donations").snapshots();
  }

  Future<String> deleteDonation(String? id) async {
    try {
      await db.collection("donations").doc(id).delete();
      return "Successfully deleted donation!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editDonation(String? id) async {
    // TODO: fill edit Donation
    return "Dummy string";
  }
}

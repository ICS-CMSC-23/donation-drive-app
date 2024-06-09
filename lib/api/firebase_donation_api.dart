import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/donation_model.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Donation donation) async {
    try {
      DocumentReference docRef =
          await db.collection('donations').add(donation.toJson());
      await docRef.update({'id': docRef.id});
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

  Future<String> editDonation(
      String? id, Map<String, dynamic> updatedData) async {
    try {
      await db.collection("donations").doc(id).update(updatedData);
      return "Successfully edited donation!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}

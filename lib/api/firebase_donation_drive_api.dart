import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonationDrive(Map<String, dynamic> donationDrive) async {
    try {
      DocumentReference docRef =
          await db.collection('donationDrives').add(donationDrive);
      await docRef.update({'id': docRef.id});
      return "Successfully added donation drive!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonationDrives() {
    return db.collection("donationDrives").snapshots();
  }

  Future<String> deleteDonationDrive(String? id) async {
    try {
      await db.collection("donationDrives").doc(id).delete();
      return "Successfully deleted donation drive!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editDonationDrive(String id, Map<String, dynamic> data) async {
    try {
      await db.collection("donationDrives").doc(id).update(data);
      return "Successfully edited donation drive!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}

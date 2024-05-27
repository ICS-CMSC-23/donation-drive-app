import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonationDrive(Map<String, dynamic> donationDrive) async {
    try {
      await db.collection('donationDrives').add(donationDrive);
      return "Successfully added donation drive!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonationDrives() {
    print(db.collection("donationDrives").snapshots());
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

  Future<String> editDonationDrive(String? id) async {
    // TODO: fill edit Donation
    return "Dummy string";
  }
}

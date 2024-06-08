import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonorAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonor(Map<String, dynamic> donor) async {
    try {
      await db.collection('donors').add(donor);
      return "Successfully added donor!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonors() {
    print(db.collection("donors").snapshots());
    return db.collection("donors").snapshots();
  }

  Future<String> deleteDonor(String? id) async {
    try {
      await db.collection("donors").doc(id).delete();
      return "Successfully deleted donor!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editDonor(String? id) async {
    // TODO: fill edit Donor
    return "Dummy string";
  }
}

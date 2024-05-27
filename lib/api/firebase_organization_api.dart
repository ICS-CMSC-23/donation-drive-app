import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOrganizationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addOrganization(Map<String, dynamic> organization) async {
    try {
      await db.collection('organizations').add(organization);
      return "Successfully added organization!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllOrganizations() {
    print(db.collection("organizations").snapshots());
    return db.collection("organizations").snapshots();
  }

  Future<String> deleteOrganization(String? id) async {
    try {
      await db.collection("organizations").doc(id).delete();
      return "Successfully deleted organization!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editOrganization(String? id) async {
    // TODO: fill edit organization
    return "Dummy string";
  }
}

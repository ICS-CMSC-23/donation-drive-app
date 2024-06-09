import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/organization_model.dart';

class FirebaseOrganizationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addOrganization(Map<String, dynamic> organization) async {
    try {
      DocumentReference docRef =
          await db.collection('organizations').add(organization);
      await docRef.update({'id': docRef.id});
      return "Successfully added organization with ID: ${docRef.id}";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllOrganizations() {
    return db.collection("organizations").snapshots();
  }

  Future<Organization?> getOrganizationByUsername(String username) async {
    final QuerySnapshot result = await db
        .collection('organizations')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      Map<String, dynamic> data =
          result.docs.first.data() as Map<String, dynamic>;
      data['id'] = result.docs.first.id;
      return Organization.fromJson(data);
    }
    return null;
  }

  Future<String> deleteOrganization(String? id) async {
    try {
      await db.collection("organizations").doc(id).delete();
      return "Successfully deleted organization!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editOrganization(String? id, Map<String, dynamic> data) async {
    try {
      await db.collection("organizations").doc(id).update(data);
      return "Successfully edited organization!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}

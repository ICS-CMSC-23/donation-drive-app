import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_jdvillamin/models/organization_model.dart'; // Make sure to import the Organization model

class ViewAllOrgs extends StatelessWidget {
  const ViewAllOrgs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 61, 78, 1),
      appBar: AppBar(
        title: const Text("View All Organizations"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('organizations')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                Organization organization = Organization.fromJson(data);
                return _buildOrganizationCard(organization);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrganizationCard(Organization org) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              org.organizationName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'About: ${org.about}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Address: ${org.addresses.join(", ")}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Contact: ${org.contactNo}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Proofs of Legitimacy: ${org.proofsOfLegitimacy.join(", ")}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${org.isApproved ? "Approved" : "Not Approved"}',
              style: TextStyle(
                  fontSize: 16,
                  color: org.isApproved ? Colors.green : Colors.red),
            ),
            SizedBox(height: 8),
            Text(
              'Open Status: ${org.isOpen ? "Open" : "Closed"}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Donation Drives: ${org.donationDriveIds.join(", ")}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

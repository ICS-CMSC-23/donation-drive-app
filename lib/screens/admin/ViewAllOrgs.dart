import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_jdvillamin/models/organization_model.dart'; // Ensure you import the Organization model correctly

class ViewAllOrgs extends StatelessWidget {
  const ViewAllOrgs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 61, 78, 1),
      appBar: AppBar(
        title: const Text(
          "View All Organizations",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.white, // White text color
          ),
        ),
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
            _buildBoldText('About:', org.about),
            SizedBox(height: 8),
            _buildBoldText('Address:', org.addresses.join(", ")),
            SizedBox(height: 8),
            _buildBoldText('Contact:', org.contactNo),
            SizedBox(height: 8),
            _buildBoldText(
                'Proofs of Legitimacy:', org.proofsOfLegitimacy.join(", ")),
            SizedBox(height: 8),
            Text(
              'Status: ${org.isApproved ? "Approved" : "Not Approved"}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: org.isApproved ? Colors.green : Colors.red),
            ),
            SizedBox(height: 8),
            _buildBoldText('Open Status:', org.isOpen ? "Open" : "Closed"),
            SizedBox(height: 8),
            _buildBoldText('Donation Drives:', org.donationDriveIds.join(", ")),
          ],
        ),
      ),
    );
  }

  Widget _buildBoldText(String label, String? value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black, // Default text color
          fontSize: 18,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value ?? 'Not available', // Provide a default value if null
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

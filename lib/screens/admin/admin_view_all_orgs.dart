import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_jdvillamin/models/organization_model.dart';

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
                Organization organization = Organization.fromJson(
                    document.data()! as Map<String, dynamic>);
                return _buildOrganizationCard(organization, document.id);
              }).toList(),
            );
          },
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

  Widget _buildAddressText(String label, List<String> addresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        ...addresses
            .map((address) => Text(address,
                style: const TextStyle(fontSize: 16, color: Colors.black)))
            .toList(),
      ],
    );
  }

  Widget _buildStatusText(String label, bool isApproved) {
    return Row(
      children: [
        Text(
          '$label ',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          isApproved ? "Approved" : "Not Approved",
          style: TextStyle(
            fontSize: 18,
            color: isApproved ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildProofsOfLegitimacy(List<String>? urls) {
    if (urls == null || urls.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          'No proofs of legitimacy available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Proofs of Legitimacy:',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: urls.map((url) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  url,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    // Return an error icon or a placeholder image
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                      child: const Icon(Icons.error, color: Colors.white),
                      alignment: Alignment.center,
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleApprovalButton(String docId, bool isApproved) {
    return ElevatedButton(
      onPressed: () {
        // This will toggle the approval status
        FirebaseFirestore.instance
            .collection('organizations')
            .doc(docId)
            .update({'isApproved': !isApproved});
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isApproved
            ? Colors.red
            : Colors.green, // Lighter green when not approved
        foregroundColor: Colors.white, // White text color for both
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold, // Bold text
          fontSize: 16, // Larger text size
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20), // Padding for better sizing
      ),
      child: Text(isApproved ? 'Disapprove' : 'Approve'),
    );
  }

  Widget _buildOrganizationCard(Organization org, String docId) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(org.organizationName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildBoldText('About:', org.about),
            SizedBox(height: 8),
            _buildAddressText('Address:', org.addresses),
            SizedBox(height: 8),
            _buildBoldText('Contact Number:', org.contactNo),
            SizedBox(height: 8),
            _buildProofsOfLegitimacy(org.proofsOfLegitimacy),
            SizedBox(height: 8),
            _buildStatusText('Status:', org.isApproved),
            SizedBox(height: 8),
            _buildBoldText('Open Status:', org.isOpen ? "Open" : "Closed"),
            SizedBox(height: 8),
            _buildBoldText('Donation Drives:', org.donationDriveIds.join(", ")),
            SizedBox(height: 8),
            _buildToggleApprovalButton(docId, org.isApproved),
          ],
        ),
      ),
    );
  }
}

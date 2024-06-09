import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_jdvillamin/models/donor_model.dart'; // Ensure you have a Donor model

class ViewAllDonors extends StatelessWidget {
  const ViewAllDonors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View All Donors"),
        backgroundColor: Colors.blue, // Set your desired color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('donors').snapshots(),
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
                Donor donor = Donor.fromJson(data);
                return _buildDonorSection(donor);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDonorSection(Donor donor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          donor.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text("User ID: ${donor.userId}"),
        Text("Username: ${donor.username}"),
        ...donor.addresses.map((address) => Text("Address: $address")).toList(),
        Text("Contact No: ${donor.contactNo}"),
        const Divider(),
      ],
    );
  }
}

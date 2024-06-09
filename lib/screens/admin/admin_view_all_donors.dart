import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_jdvillamin/models/donor_model.dart';

class ViewAllDonors extends StatelessWidget {
  const ViewAllDonors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 61, 78, 1),
      appBar: AppBar(
        title: const Text(
          "View All Donors",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              donor.name,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            _buildTextRow('User ID:', donor.userId.toString()),
            const SizedBox(height: 10),
            _buildTextRow('Username:', donor.username),
            const SizedBox(height: 10),
            _buildAddressSection('Address:', donor.addresses),
            const SizedBox(height: 10),
            _buildTextRow('Contact No:', donor.contactNo),
          ],
        ),
      ),
    );
  }

  Widget _buildTextRow(String label, String data) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: data,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(String label, List<String> addresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
}

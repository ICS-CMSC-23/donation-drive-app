import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_jdvillamin/models/donation_model.dart'; // Make sure this is the correct path

class ViewAllDonations extends StatelessWidget {
  const ViewAllDonations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromRGBO(46, 61, 78, 1), // Dark background color
      appBar: AppBar(
        title: const Text(
          "View All Donations",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('donations').snapshots(),
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
                Donation donation = Donation.fromJson(data);
                return _buildDonationCard(donation);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDonationCard(Donation donation) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Organization ID: ${donation.organizationId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Categories: ${donation.categories.join(", ")}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Pickup/Drop-off: ${donation.isPickup ? "Pick-up" : "Drop-off"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Weight: ${donation.weight} kg',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildPhotoWidget(donation.photoUrl),
            const SizedBox(height: 8),
            Text(
              'Date & Time: ${donation.dateTime}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...donation.addresses
                .map((address) => Text('Address: $address',
                    style: const TextStyle(fontSize: 16)))
                .toList(),
            const SizedBox(height: 8),
            Text(
              'Contact No: ${donation.contactNo}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${_getStatusText(donation.status)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoWidget(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return const Text('Photo: Not available', style: TextStyle(fontSize: 16));
    }
    // Assuming the photo URL is directly accessible
    return Image.network(photoUrl, width: 100, height: 100, fit: BoxFit.cover);
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Confirmed";
      case 2:
        return "Scheduled for Pick-up";
      case 3:
        return "Complete";
      case 4:
        return "Canceled";
      default:
        return "Unknown";
    }
  }
}

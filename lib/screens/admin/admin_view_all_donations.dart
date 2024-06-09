import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_jdvillamin/models/donation_model.dart';

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
                return _buildDonationCard(context, donation);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddresses(List<String> addresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Addresses:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...addresses
            .map((address) => Text(
                  address,
                  style: const TextStyle(fontSize: 16),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildTextRow(BuildContext context, String label, String data) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          TextSpan(
            text: data,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard(BuildContext context, Donation donation) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTextRow(context, 'Organization ID:',
                donation.organizationId.toString()),
            const SizedBox(height: 8),
            _buildTextRow(
                context, 'Categories:', donation.categories.join(", ")),
            const SizedBox(height: 8),
            _buildTextRow(context, 'Pickup/Drop-off:',
                donation.isPickup ? "Pick-up" : "Drop-off"),
            const SizedBox(height: 8),
            _buildTextRow(context, 'Weight:', '${donation.weight} kg'),
            const SizedBox(height: 8),
            _buildPhotoWidget(donation.photoUrl),
            const SizedBox(height: 8),
            _buildTextRow(context, 'Date & Time:', '${donation.dateTime}'),
            const SizedBox(height: 8),
            _buildAddresses(donation.addresses),
            const SizedBox(height: 8),
            _buildTextRow(context, 'Contact No:', donation.contactNo),
            const SizedBox(height: 8),
            _buildTextRow(context, 'Status:', _getStatusText(donation.status)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoWidget(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return const Text('Photo: Not available', style: TextStyle(fontSize: 16));
    }
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

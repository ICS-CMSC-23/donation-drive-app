import 'package:flutter/material.dart';
import '../../models/donor_model.dart';
import '../../models/donation_model.dart';

class DonationDetails {
  final Donor donor;
  final Donation donation;

  DonationDetails({required this.donor, required this.donation});
}

class DonationDetailsScreen extends StatelessWidget {
  final DonationDetails donationDetails;

  const DonationDetailsScreen({super.key, required this.donationDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Donor Information
            const Text(
              'Donor Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('User ID: ${donationDetails.donor.userId}'),
            Text('Name: ${donationDetails.donor.name}'),
            Text('Username: ${donationDetails.donor.username}'),
            Text('Address/es: ${donationDetails.donor.addresses.join(', ')}'),
            Text('Contact No: ${donationDetails.donor.contactNo}'),
            const SizedBox(height: 20),
            // Donation Information
            const Text(
              'Donation Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
                'Categories: ${donationDetails.donation.categories.join(', ')}'),
            const SizedBox(height: 10),
            Image.network(
              donationDetails.donation.photoUrl ?? "",
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text('Contact No: ${donationDetails.donation.contactNo}'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DonationDetails {
  final Donor donor;
  final List<String> categories;
  final String photo;
  final String donationContactNumber;

  DonationDetails({
    required this.donor,
    required this.categories,
    required this.photo,
    required this.donationContactNumber,
  });
}

class Donor {
  final String userId;
  final String name;
  final String username;
  final List<String> addresses;
  final String contactNumber;

  Donor({
    required this.userId,
    required this.name,
    required this.username,
    required this.addresses,
    required this.contactNumber,
  });
}


class DonationDetailsScreen extends StatelessWidget {
  final DonationDetails donationDetails;

  DonationDetailsScreen({required this.donationDetails});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Donor Information
            Text(
              'Donor Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('User ID: ${donationDetails.donor.userId}'),
            Text('Name: ${donationDetails.donor.name}'),
            Text('Username: ${donationDetails.donor.username}'),
            Text('Address/es: ${donationDetails.donor.addresses.join(', ')}'),
            Text('Contact No: ${donationDetails.donor.contactNumber}'),
            SizedBox(height: 20),
            // Donation Information
            Text(
              'Donation Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Categories: ${donationDetails.categories.join(', ')}'),
            SizedBox(height: 10),
            Image.network(
              donationDetails.photo,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text('Contact No: ${donationDetails.donationContactNumber}'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'organization_profile.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  _OrganizationPageState createState() => _OrganizationPageState();
}

class Donation {
  final String donorName;
  final List<String> categories;
  final String photo;
  final String contactNumber;

  Donation({
    required this.donorName,
    required this.categories,
    required this.photo,
    required this.contactNumber,
  });
}

class _OrganizationPageState extends State<OrganizationPage> {
  List<Donation> fetchDonations() {
    return [
      Donation(
        donorName: 'Ayen Nery',
        categories: ['Food', 'Clothes'],
        photo: 'null',
        contactNumber: '+1234567890',
      ),
      Donation(
        donorName: 'Hev Abi',
        categories: ['Cash'],
        photo: 'null',
        contactNumber: '+9876543210',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Fetch donation data from backend
    List<Donation> donations = fetchDonations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Homepage'),
      ),
      body: ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          return DonationCard(donation: donations[index]);
        },
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final Donation donation;

  DonationCard({required this.donation});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(donation.photo),
        ),
        title: Text(donation.donorName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories: ${donation.categories.join(', ')}'),
            Text('Contact: ${donation.contactNumber}'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrganizationProfileScreen()),
          );
        },
      ),
    );
  }
}

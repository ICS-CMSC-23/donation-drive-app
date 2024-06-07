import 'package:flutter/material.dart';

class ViewAllDonors extends StatelessWidget {
  const ViewAllDonors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromRGBO(48, 61, 78, 1), // Dark background color
      appBar: AppBar(
        title: const Text(
          "View All Donors",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text style
            color: Colors.white, // White text color for visibility
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent AppBar background
        elevation: 0,
        leading: const SizedBox(), // Ensures title aligns to the left
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDonorSection(
                context,
                "Donor 1",
                "",
                "",
                [
                  _buildDonation("Organization 1", "Complete"),
                  _buildDonation("Organization 2", "Complete"),
                  _buildDonation("Organization 3", "Complete"),
                ],
              ),
              const SizedBox(height: 20),
              _buildDonorSection(
                context,
                "Donor 2",
                "",
                "",
                [
                  _buildDonation("Organization 1", "Complete"),
                  _buildDonation("Organization 2", "Complete"),
                  _buildDonation("Organization 3", "Complete"),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonorSection(BuildContext context, String donorName,
      String address, String contact, List<Widget> donations) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              donorName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Address: $address",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              "Contact Number: $contact",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ...donations,
          ],
        ),
      ),
    );
  }

  Widget _buildDonation(String organizationName, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          organizationName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Donation 1 - $status",
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          "Donation 2 - $status",
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          "Donation 3 - $status",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

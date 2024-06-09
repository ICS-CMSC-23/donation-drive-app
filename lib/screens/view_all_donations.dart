import 'package:flutter/material.dart';

class ViewAllDonations extends StatelessWidget {
  const ViewAllDonations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromRGBO(48, 61, 78, 1), // Dark background color
      appBar: AppBar(
        title: const Text('View All Donations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildOrganizationCard("Organization 1", [
              _buildDonationDetails(
                "Donation 1 - Pending",
                "Food",
                "For pick-up",
                "5kg",
                "15th July, 09:00 AM",
                "1234 Charity St., Nonprofit City",
                "(123) 456-7890",
              ),
              _buildDonationDetails(
                "Donation 2 - Complete",
                "Clothes",
                "For drop off",
                "10kg",
                "16th July, 10:00 AM",
                "1235 Charity St., Nonprofit City",
                "(123) 456-7891",
              ),
            ]),
            const SizedBox(height: 20),
            _buildOrganizationCard("Organization 2", [
              _buildDonationDetails(
                "Donation 1 - Scheduled for Pick-up",
                "Cash",
                "For pick-up",
                "N/A",
                "17th July, 11:00 AM",
                "1236 Charity St., Nonprofit City",
                "(123) 456-7892",
              ),
              _buildDonationDetails(
                "Donation 2 - Confirmed",
                "Necessities",
                "For drop off",
                "20kg",
                "18th July, 12:00 PM",
                "1237 Charity St., Nonprofit City",
                "(123) 456-7893",
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationCard(
      String organizationName, List<Widget> donations) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              organizationName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...donations,
          ],
        ),
      ),
    );
  }

  Widget _buildDonationDetails(
    String status,
    String category,
    String deliveryMethod,
    String weight,
    String dateTime,
    String address,
    String contact,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("Category: $category"),
        Text("$deliveryMethod"),
        Text("Weight: $weight"),
        Text("Date & Time: $dateTime"),
        Text("Address: $address"),
        Text("Contact number: $contact"),
        const SizedBox(height: 20),
      ],
    );
  }
}

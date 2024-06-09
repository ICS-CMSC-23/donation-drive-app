import 'package:flutter/material.dart';

class ViewAllDonations extends StatelessWidget {
  const ViewAllDonations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromRGBO(48, 61, 78, 1), // Dark background color
      appBar: AppBar(
        title: const Text(
          'View All Donations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Making the AppBar title white and bold
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildOrganizationCard(context, "Organization 1", [
                  _buildDonationDetails(
                    "Donation name",
                    "status",
                    "category",
                    "drop off/pickup",
                    "weight",
                    "date",
                    "address",
                    "contact number",
                  ),
                  _buildDonationDetails(
                    "Donation name",
                    "status",
                    "category",
                    "drop off/pickup",
                    "weight",
                    "date",
                    "address",
                    "contact number",
                  ),
                ]),
                const SizedBox(height: 20),
                _buildOrganizationCard(context, "Organization 2", [
                  _buildDonationDetails(
                    "Donation name",
                    "status",
                    "category",
                    "drop off/pickup",
                    "weight",
                    "date",
                    "address",
                    "contact number",
                  ),
                  _buildDonationDetails(
                    "Donation name",
                    "status",
                    "category",
                    "drop off/pickup",
                    "weight",
                    "date",
                    "address",
                    "contact number",
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationCard(
      BuildContext context, String organizationName, List<Widget> donations) {
    return Card(
      color: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.9, // Fixed width to 90% of screen width
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
    String donationName,
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
        Text(donationName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("Status: $status"),
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

import 'package:flutter/material.dart';

class ViewAllDonors extends StatelessWidget {
  const ViewAllDonors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View All Donors"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDonorSection(
              "Donor 1",
              [
                _buildDonation("Organization 1", "Complete"),
                _buildDonation("Organization 2", "Complete"),
                _buildDonation("Organization 3", "Complete"),
              ],
            ),
            const Divider(),
            _buildDonorSection(
              "Donor 2",
              [
                _buildDonation("Organization 1", "Complete"),
                _buildDonation("Organization 2", "Complete"),
                _buildDonation("Organization 3", "Complete"),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorSection(String donorName, List<Widget> donations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          donorName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: donations,
        ),
      ],
    );
  }

  Widget _buildDonation(String organizationName, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          organizationName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline, // Add underline
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Donation 1 - $status",
        ),
        Text(
          "Donation 2 - $status",
        ),
        Text(
          "Donation 3 - $status",
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

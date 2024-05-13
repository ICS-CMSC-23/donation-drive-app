// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'DonorProfile.dart';

class DonorPage extends StatefulWidget {
  const DonorPage({super.key});

  @override
  _DonorPageState createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  List<String> organizations = [
    "Organization 1",
    "Organization 2",
    "Organization 3",
    "Organization 4",
  ];

  void approveOrganization(int index) {
    // Remove the organization from the list
    organizations.removeAt(index);

    // Show snackbar message for approval
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Organization chosen"),
      ),
    );

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Donor Homepage"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: organizations
                  .map(
                    (org) => _buildOrganizationCard(org,
                        () => approveOrganization(organizations.indexOf(org))),
                  )
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DonorProfile()),
            );
          },
        ));
  }

  Widget _buildOrganizationCard(String name, VoidCallback onApprove) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "About the organization",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: onApprove,
                  child: const Text("Select this organization"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

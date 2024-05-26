// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'ApproveOrg.dart';
import '../organization/ViewAllDonors.dart';
import '../donor/ViewAllOrgs.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Elbi Donation System"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Welcome, admin",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewAllOrgs()),
                );
              },
              child: const Text('View All Organizations and Donations'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApproveOrg()),
                );
              },
              child: const Text('Approve Organization'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewAllDonors()),
                );
              },
              child: const Text('View All Donors'),
            ),
          ],
        ),
      ),
    );
  }
}

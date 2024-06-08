// donor_profile.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/donor_provider.dart';
import '../../models/donor_model.dart';
import 'donor_page.dart';

class DonorProfile extends StatelessWidget {
  const DonorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);
    final donorProvider = Provider.of<DonorListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Profile"),
      ),
      body: FutureBuilder<Donor?>(
        future:
            donorProvider.getDonorByEmail(authProvider.userObj?.email ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading donor data"));
          } else {
            final donor = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hello, ${donor.name}!",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "Donor Name: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donor.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Donor Address: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donor.addresses.join(", "),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Donor Contact Number: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donor.contactNo,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Number of donations made: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "9", // This should be replaced with actual data once available.
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Donation History",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.account_circle),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DonorPage()),
          );
        },
      ),
    );
  }
}

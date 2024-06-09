import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/organization_provider.dart';
import '../../providers/auth_provider.dart'; // Import the auth provider
import 'donor_profile.dart';
import 'donate_form.dart';
import '../../models/organization_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorPage extends StatefulWidget {
  const DonorPage({super.key});

  @override
  _DonorPageState createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  void approveOrganization(Organization organization) {
    // Navigate to DonationFormPage with the selected organization
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonationFormPage(organization: organization),
      ),
    );

    // Show snackbar message for approval
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Organization chosen"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<MyAuthProvider>(context); // Get the auth provider

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Homepage"),
      ),
      body: Consumer<OrganizationListProvider>(
        builder: (context, provider, _) {
          return StreamBuilder<QuerySnapshot>(
            stream: provider.organizations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error loading organizations"));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No organizations found"));
              } else {
                var organizations = snapshot.data!.docs.map((doc) {
                  return Organization.fromJson(
                      doc.data() as Map<String, dynamic>);
                }).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: organizations.map((org) {
                        return _buildOrganizationCard(
                          org,
                          () => approveOrganization(org),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'profileButton',
            child: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DonorProfile()),
              );
            },
          ),
          const SizedBox(height: 16), // Add some space between the buttons
          FloatingActionButton(
            heroTag: 'signOutButton',
            child: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authProvider.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationCard(
      Organization organization, VoidCallback onApprove) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              organization.organizationName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              organization.about ?? "No description available",
              style: const TextStyle(
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

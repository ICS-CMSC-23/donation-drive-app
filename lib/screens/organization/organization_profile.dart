import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/organization_provider.dart';
import '../../models/organization_model.dart';

class OrganizationProfileScreen extends StatefulWidget {
  const OrganizationProfileScreen({super.key});

  @override
  State<OrganizationProfileScreen> createState() =>
      _OrganizationProfileScreenState();
}

class _OrganizationProfileScreenState extends State<OrganizationProfileScreen> {
  bool _donationStatus = true;
  Organization? _organization;

  @override
  void initState() {
    super.initState();
    _fetchOrganizationDetails();
  }

  void _fetchOrganizationDetails() async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final organizationProvider =
        Provider.of<OrganizationListProvider>(context, listen: false);

    final email = authProvider.userObj?.email;
    if (email != null) {
      final organization =
          await organizationProvider.getOrganizationByUsername(email);
      if (organization != null) {
        // Explicitly set the id from Firestore if it's not already set
        organization.id = (organization.id ??
            organizationProvider.getDocumentIdByUsername(email)) as String?;

        setState(() {
          _organization = organization;
          _donationStatus = organization.isOpen;
        });
      }
    }
  }

  void _toggleDonationStatus(bool status) {
    setState(() {
      _donationStatus = status;
    });

    final organizationProvider =
        Provider.of<OrganizationListProvider>(context, listen: false);
    if (_organization != null) {
      organizationProvider
          .editOrganization(_organization!.id, {'isOpen': status});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_organization == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Organization Profile'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Organization Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(_organization!.organizationName),
            SizedBox(height: 20),
            Text(
              'About the Organization:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(_organization!.about ?? 'No description available'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status for Donations:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _donationStatus,
                  onChanged: _toggleDonationStatus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

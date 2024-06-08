import 'package:flutter/material.dart';

class OrganizationProfileScreen extends StatefulWidget {
  @override
  _OrganizationProfileScreenState createState() => _OrganizationProfileScreenState();
}

class _OrganizationProfileScreenState extends State<OrganizationProfileScreen> {
  bool _donationStatus = true; // Default donation status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organization Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Your Organization Name'),
            SizedBox(height: 20),
            Text(
              'About the Organization:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Description about your organization...'),
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
                  onChanged: (value) {
                    setState(() {
                      _donationStatus = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

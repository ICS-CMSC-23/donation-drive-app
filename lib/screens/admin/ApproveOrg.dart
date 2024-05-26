import 'package:flutter/material.dart';

class ApproveOrg extends StatefulWidget {
  @override
  _ApproveOrgState createState() => _ApproveOrgState();
}

class _ApproveOrgState extends State<ApproveOrg> {
  List<String> organizations = [
    "Organization 1",
    "Organization 2",
    "Organization 3",
  ];

  void approveOrganization(int index) {
    // Remove the organization from the list
    organizations.removeAt(index);

    // Show snackbar message for approval
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Organization Approved"),
      ),
    );

    // Update the UI
    setState(() {});
  }

  void rejectOrganization(int index) {
    // Remove the organization from the list
    organizations.removeAt(index);

    // Show snackbar message for rejection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Organization Rejected"),
      ),
    );

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approve Organization"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: organizations
                .map(
                  (org) => _buildOrganizationCard(
                    org,
                    () => approveOrganization(organizations.indexOf(org)),
                    () => rejectOrganization(organizations.indexOf(org)),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationCard(
      String name, VoidCallback onApprove, VoidCallback onReject) {
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
            const SizedBox(height: 10),
            InkWell(
              child: const Text(
                "Proof",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                // Add onTap functionality for proof
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: onApprove,
                  child: const Text("Approve"),
                ),
                ElevatedButton(
                  onPressed: onReject,
                  child: const Text("Reject"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

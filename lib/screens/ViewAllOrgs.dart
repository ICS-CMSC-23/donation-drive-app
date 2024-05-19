import 'package:flutter/material.dart';

class ViewAllOrgs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View All Organizations"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildOrganization(
                "Organization Name",
                "Open",
                [
                  "Donation 1 - Complete",
                  "Donation 2 - Scheduled for pick-up",
                  "Donation 3 - Pending",
                ],
              ),
              const Divider(),
              _buildOrganization(
                "Organization Name",
                "Closed",
                [
                  "Donation 1 - Complete",
                  "Donation 2 - Confirmed",
                  "Donation 3 - Canceled",
                ],
              ),
              const Divider(),
              _buildOrganization(
                "Organization Name",
                "Open",
                [
                  "Donation 1 - Confirmed",
                  "Donation 2 - Pending",
                  "Donation 3 - Pending",
                ],
              ),
              const Divider(),
              _buildOrganization(
                "Organization Name",
                "Closed",
                [
                  "Donation 1 - Complete",
                  "Donation 2 - Confirmed",
                  "Donation 3 - Confirmed",
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganization(
      String name, String status, List<String> donations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Text(
              "Status for donations: ",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 16,
                color: status == "Open" ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Donation List:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: donations
              .map((donation) => Text(
                    donation,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ViewAllOrgs extends StatelessWidget {
  const ViewAllOrgs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 61, 78, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "List of Organizations",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildOrganization(
                  context,
                  "Organization A",
                  "Open",
                  "Description",
                  "Address",
                  "0922 999 2232",
                  {
                    "Donation Drive A": [
                      "Donation 1 - Complete",
                      "Donation 2 - Scheduled for pick-up",
                      "Donation 3 - Pending",
                    ],
                    "Donation Drive B": [
                      "Donation 1 - Pending",
                      "Donation 2 - Complete",
                    ],
                  },
                ),
                const SizedBox(height: 20),
                _buildOrganization(
                  context,
                  "Organization B",
                  "Closed",
                  "Description",
                  "Address",
                  "0922 999 2232",
                  {
                    "Donation Drive C": [
                      "Donation 1 - Complete",
                      "Donation 2 - Confirmed",
                      "Donation 3 - Canceled",
                    ],
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrganization(
      BuildContext context,
      String name,
      String status,
      String description,
      String address,
      String contact,
      Map<String, List<String>> donationDrives) {
    return Card(
      color: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Text(
              "Address:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              address,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Text(
              "Contact Number:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              contact,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Status of donations:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: status == "Open" ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...donationDrives.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildDonationDrive(entry.key, entry.value),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationDrive(String driveName, List<String> donations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          driveName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        ...donations.map((donation) => Text(
              donation,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            )),
      ],
    );
  }
}

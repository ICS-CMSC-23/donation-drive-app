import 'package:flutter/material.dart';
import 'admin_view_all_donors.dart';
import 'admin_view_all_orgs.dart';
import 'admin_view_all_donations.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromRGBO(46, 61, 78, 1), // Dark background color
      appBar: AppBar(
        title: const Text(
          "Elbi Donation System",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent AppBar background
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Colors.white, // White card background
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Minimize height based on content
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Welcome, Admin",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromRGBO(255, 63, 64, 1), // Text color
                      minimumSize: Size(
                          double.infinity, 50), // Full width and fixed height
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewAllOrgs()),
                      );
                    },
                    child: const Text(
                      'View All Organizations',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromRGBO(255, 63, 64, 1), // Text color
                      minimumSize: Size(
                          double.infinity, 50), // Full width and fixed height
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewAllDonors()),
                      );
                    },
                    child: const Text(
                      'View All Donors',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromRGBO(255, 63, 64, 1), // Text color
                      minimumSize: Size(
                          double.infinity, 50), // Full width and fixed height
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewAllDonations()),
                      );
                    },
                    child: const Text(
                      'View All Donations',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

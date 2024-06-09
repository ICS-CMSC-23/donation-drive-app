import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donationdetail.dart';
import '/models/donation_model.dart'; // Assuming you have the Donation model defined

class DonationHistoryPage extends StatelessWidget {
  const DonationHistoryPage({Key? key}) : super(key: key);

  // Fetch the donor ID based on the Firebase UID
  Future<int?> fetchDonorId(String uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('donors')
          .where('username', isEqualTo: uid) // Assuming 'username' is the Firebase UID
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.get('userId');
      } else {
        print("No donor found with UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching donor ID: $e");
      return null;
    }
  }

  // Fetch the donations based on the donor ID
  Future<List<Donation>> fetchDonations(int donorId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('donorId', isEqualTo: donorId)
          .get();

      return querySnapshot.docs
          .map((doc) => Donation.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching donations: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("User not logged in"));
    }

    final String uid = user.email!; // Assuming the email is used as the UID in the 'username' field

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation History"),
      ),
      body: FutureBuilder<int?>(
        future: fetchDonorId(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No donor ID found."));
          } else {
            final int donorId = snapshot.data!;
            return FutureBuilder<List<Donation>>(
              future: fetchDonations(donorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No donations found."));
                } else {
                  final List<Donation> donations = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.17, // Adjusted aspect ratio for larger cards
                      ),
                      itemCount: donations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DonationDetailPage(donation: donations[index]),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            child: Container(
                              height: 800, // Adjusting the height of the card
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      donations[index].categories.join(", "),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Weight: ${donations[index].weight} kg",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Date: ${donations[index].dateTime.toLocal().toString().split(' ')[0]}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10), // Added spacing below the date
                                    Text(
                                      donations[index].isPickup ? "Pickup" : "Dropoff", // Display pickup or dropoff
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildStatusWidget(donations[index].status), // Display status
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildStatusWidget(int status) {
    Color statusColor = Colors.green; // Default color for confirmed status

    // Set color based on status
    switch (status) {
      case 0:
        statusColor = Colors.yellow; // Pending
        break;
      case 1:
        statusColor = Colors.green; // Confirmed
        break;
      case 2:
        statusColor = Colors.blue; // Scheduled for pick-up
        break;
      case 3:
        statusColor = Colors.grey; // Complete
        break;
      case 4:
        statusColor = Colors.red; // Canceled
        break;
    }

    return Container(
      padding: const EdgeInsets
      .symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        "Status: ${_getStatusText(status)}",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  String _getStatusText(int status) {
    // Define status text based on status code
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Confirmed";
      case 2:
        return "Scheduled for pick-up";
      case 3:
        return "Complete";
      case 4:
        return "Canceled";
      default:
        return "Unknown";
    }
  }
}

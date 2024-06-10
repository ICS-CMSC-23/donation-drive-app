import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/models/donation_model.dart'; // Assuming you have the Donation model defined

class DonationDetailPage extends StatelessWidget {
  final Donation donation;

  const DonationDetailPage({Key? key, required this.donation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Category: ${donation.categories.join(", ")}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Weight: ${donation.weight} kg",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Date: ${donation.dateTime.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            // Add condition to check if it's dropoff and pending
            if (!donation.isPickup && donation.status == 0)
              Container(
                alignment: Alignment.center,
                child: QrImageView(
                  data: donation.id ?? 'unknown', // Provide a fallback value
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
          ],
        ),
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

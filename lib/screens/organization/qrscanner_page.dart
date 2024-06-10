import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '/models/donation_model.dart';
import '/providers/donation_provider.dart';
import '/providers/auth_provider.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scanned = false;
  String? scannedData;
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          if (scanned) // Show the scanned data if a successful scan occurred
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    message,
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Scanned Donation ID: $scannedData',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // Check if scanning has already occurred
      if (!scanned) {
        // Update the flag to indicate a successful scan
        setState(() {
          scanned = true;
          scannedData = scanData.code!;
        });

        // Stop scanning further
        controller.stopCamera();

        // Perform the necessary checks
        await _handleScannedData(scannedData!);
      }
    });
  }

  Future<void> _handleScannedData(String scannedData) async {
    try {
      // Fetch the donation details
      final donationProvider = Provider.of<DonationListProvider>(context, listen: false);
      QuerySnapshot donationSnapshot = await donationProvider.donations.first;
      final donationDoc = donationSnapshot.docs.firstWhere(
        (doc) => doc.id == scannedData,
        // ignore: cast_from_null_always_fails
        orElse: () => null as QueryDocumentSnapshot<Object?>,
      );

      Donation donation = Donation.fromJson(donationDoc.data() as Map<String, dynamic>);

      // Check if the donation is pending
      if (donation.status == 0) {
        // Get the current user's email
        final currentUserEmail = Provider.of<MyAuthProvider>(context, listen: false).currentUser?.email;

        // Query the Firestore collection of organizations
        final organizationSnapshot = await FirebaseFirestore.instance
            .collection('organizations')
            .where('username', isEqualTo: currentUserEmail)
            .get();

        // Check if an organization document is found
        if (organizationSnapshot.docs.isNotEmpty) {
          // Retrieve the organization's user ID
          final organizationUserId = organizationSnapshot.docs.first['userId'];

          // Compare the organization's user ID with the donation's organization ID
          if (donation.organizationId == organizationUserId) {
            // The donation is valid and the organization IDs match
            // Update the donation status to confirmed
            donationProvider.editDonation(donation.id!, {'status': 1});
            _showConfirmationDialog(context);

            setState(() {
              message = 'Donation confirmed';
            });
          } else {
            setState(() {
              message = 'User ID does not match the donation\'s organization ID';
            });
          }
        } else {
          setState(() {
            message = 'Organization not found for the current user';
          });
        }
      } else {
        setState(() {
          message = 'Donation is not pending';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error occurred while processing the QR code';
      });
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Donation Confirmed'),
          content: const Text('The donation has been confirmed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to the organization page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

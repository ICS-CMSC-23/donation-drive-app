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
      // Fetch the donation details
      final donationProvider = Provider.of<DonationListProvider>(context, listen: false);
      donationProvider.editDonation(scannedData, {"status":3});  
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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

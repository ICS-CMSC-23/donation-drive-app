import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '/providers/donation_provider.dart';

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
        title: const Text('Scan QR Code'),
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
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Scanned Donation ID: $scannedData',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: scanned ? null : null,
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
    Provider.of<DonationListProvider>(context, listen: false);
    _showOptionsBottomSheet(context);
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Accept Donation'),
              onTap: () {
                _acceptDonation();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Reject Donation'),
              onTap: () {
                _rejectDonation();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _acceptDonation() {
    // Handle accepting the donation
    final donationProvider =
        Provider.of<DonationListProvider>(context, listen: false);
    donationProvider.editDonation(scannedData!, {"status": 3});
    setState(() {
      message = 'Donation accepted';
    });
  }

  void _rejectDonation() {
    // Handle rejecting the donation
    final donationProvider =
        Provider.of<DonationListProvider>(context, listen: false);
    donationProvider.editDonation(scannedData!, {"status": 5});
    setState(() {
      message = 'Donation rejected';
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class DonationDetailPage extends StatelessWidget {
  const DonationDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation Detail"),
      ),
      body: const Center(
        child: Text("Donation Detail Page"),
      ),
    );
  }
}

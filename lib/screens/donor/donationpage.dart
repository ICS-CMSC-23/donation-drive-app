import 'package:flutter/material.dart';
import 'donationdetail.dart';

class DonationHistoryPage extends StatelessWidget {
  const DonationHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> donations = [
      {"category": "Food", "weight": "5 kg", "date": "2024-06-01"},
      {"category": "Clothes", "weight": "3 kg", "date": "2024-05-21"},
      {"category": "Cash", "weight": "\$100", "date": "2024-05-15"},
      {"category": "Necessities", "weight": "10 kg", "date": "2024-05-10"},
      {"category": "Others", "weight": "5 kg", "date": "2024-04-30"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemCount: donations.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DonationDetailPage(),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        donations[index]['category']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Weight: ${donations[index]['weight']}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Date: ${donations[index]['date']}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

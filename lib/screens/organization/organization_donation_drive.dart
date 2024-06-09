import 'package:flutter/material.dart';

class DonationDrive {
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final List<String> proofPhotos;

  DonationDrive({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.proofPhotos,
  });
}

// (replace with backend)
List<DonationDrive> fetchDonationDrives() {
  return [
    DonationDrive(
      name: 'Donation Drive 1',
      description: 'Description of Donation Drive 1',
      startDate: '2024-06-01',
      endDate: '2024-06-30',
      proofPhotos: ['image1', 'image2'],
    ),
    DonationDrive(
      name: 'Donation Drive 2',
      description: 'Description of Donation Drive 2',
      startDate: '2024-07-01',
      endDate: '2024-07-31',
      proofPhotos: ['image1', 'image2'],
    ),
  ];
}

class DonationDrivesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch donation drive data from backend
    List<DonationDrive> donationDrives = fetchDonationDrives();

    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Drives'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by donation drive name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          // Donation Drives List
          Expanded(
            child: ListView.builder(
              itemCount: donationDrives.length,
              itemBuilder: (context, index) {
                return DonationDriveItem(donationDrive: donationDrives[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to screen to add new donation drive
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class DonationDriveItem extends StatelessWidget {
  final DonationDrive donationDrive;

  DonationDriveItem({required this.donationDrive});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(donationDrive.name),
        subtitle: Text('${donationDrive.startDate} - ${donationDrive.endDate}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

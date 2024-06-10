import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/donation_model.dart';
import '../../models/donor_model.dart';
import '../../models/donation_drive_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/donor_provider.dart';
import '../../providers/donation_drive_provider.dart';
import '../../providers/auth_provider.dart';
import 'organization_profile.dart';
import 'organization_donation.dart';
import 'organization_donation_drive.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  @override
  Widget build(BuildContext context) {
    final donationDriveProvider =
        Provider.of<DonationDriveListProvider>(context);
    final donationProvider = Provider.of<DonationListProvider>(context);
    final donorProvider = Provider.of<DonorListProvider>(context);
    final authProvider = Provider.of<MyAuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(48, 61, 78, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(48, 61, 78, 1),
        title: const Text(
          'Organization Homepage',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, // Bold text
            color: Colors.white, // White text color
          ),
        ),
      ),
      body: StreamBuilder(
        stream: donationProvider.donations,
        builder: (context, AsyncSnapshot donationSnapshot) {
          if (donationSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!donationSnapshot.hasData) {
            return const Center(child: Text('No donations available'));
          }

          List<Donation> donations = donationSnapshot.data.docs
              .map<Donation>((doc) =>
                  Donation.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          print('Fetched Donations: ${donations[0].donorId}');

          return StreamBuilder(
            stream: donorProvider.donors,
            builder: (context, AsyncSnapshot donorSnapshot) {
              if (donorSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!donorSnapshot.hasData) {
                return const Center(child: Text('No donors available'));
              }

              List<Donor> donors = donorSnapshot.data.docs
                  .map<Donor>((doc) =>
                      Donor.fromJson(doc.data() as Map<String, dynamic>))
                  .toList();

              print('Donors: $donors');

              return ListView.builder(
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  Donation donation = donations[index];
                  Donor? donor = donors.firstWhere(
                      (donor) => donor.userId == donation.donorId,
                      orElse: () => Donor(
                          userId: null,
                          id: null,
                          name: 'Unknown',
                          username: 'Unknown',
                          password: 'Unknown',
                          addresses: [],
                          contactNo: 'Unknown'));

                  return DonationCard(
                      donor: donor,
                      donation: donation,
                      donationDrives: donationDriveProvider.donationDrives);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'profileButton',
            child: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrganizationProfileScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'donationDriveButton',
            child: const Icon(Icons.add_business),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonationDrivesScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'signOutButton',
            child: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authProvider.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class DonationCard extends StatefulWidget {
  final Donor donor;
  final Donation donation;
  final List<DonationDrive> donationDrives;

  const DonationCard({
    super.key,
    required this.donor,
    required this.donation,
    required this.donationDrives,
  });

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  String? selectedDriveId;
  int selectedStatus = 0;
  List<String> statusLabels = [
    "Pending",
    "Confirmed",
    "Schedule for Pick-up",
    "Complete",
    "Canceled"
  ];

  @override
  void initState() {
    super.initState();
    selectedDriveId = widget.donation.donationDriveId;
    selectedStatus = widget.donation.status;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: widget.donation.photoUrl == 'null'
              ? null
              : NetworkImage(widget.donation.photoUrl ?? ""),
          child: widget.donation.photoUrl == 'null'
              ? const Icon(Icons.image)
              : null,
        ),
        title: Text(widget.donor.username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories: ${widget.donation.categories.join(', ')}'),
            Text('Contact: ${widget.donation.contactNo}'),
            DropdownButton<String>(
              hint: const Text("Select Donation Drive"),
              value: selectedDriveId,
              items: widget.donationDrives.map((drive) {
                return DropdownMenuItem<String>(
                  value: drive.id,
                  child: Text(drive.name),
                );
              }).toList(),
              onChanged: (newValue) async {
                setState(() {
                  selectedDriveId = newValue;
                });

                // Update the donation with the selected donation drive ID
                final donationProvider =
                    Provider.of<DonationListProvider>(context, listen: false);
                donationProvider.editDonation(
                    widget.donation.id!, {'donationDriveId': newValue});
              },
            ),
            DropdownButton<int>(
              hint: const Text("Select Status"),
              value: selectedStatus,
              items: List.generate(statusLabels.length, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(statusLabels[index]),
                );
              }),
              onChanged: (newValue) async {
                setState(() {
                  selectedStatus = newValue!;
                });

                // Update the donation with the selected status
                final donationProvider =
                    Provider.of<DonationListProvider>(context, listen: false);
                donationProvider
                    .editDonation(widget.donation.id!, {'status': newValue});
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DonationDetailsScreen(
                      donationDetails: DonationDetails(
                          donor: widget.donor, donation: widget.donation),
                    )),
          );
        },
      ),
    );
  }
}

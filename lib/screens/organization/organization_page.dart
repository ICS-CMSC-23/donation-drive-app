import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/donation_model.dart';
import '../../models/donor_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/donor_provider.dart';
import 'organization_profile.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  @override
  Widget build(BuildContext context) {
    // Fetch donation data from the provider
    final donationProvider = Provider.of<DonationListProvider>(context);
    final donorProvider = Provider.of<DonorListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Homepage'),
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
                    donorName: donor.name,
                    categories: donation.categories,
                    photo: donation.photoUrl ?? 'null',
                    contactNumber: donor.contactNo,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final String donorName;
  final List<String> categories;
  final String photo;
  final String contactNumber;

  DonationCard({
    required this.donorName,
    required this.categories,
    required this.photo,
    required this.contactNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: photo == 'null' ? null : NetworkImage(photo),
          child: photo == 'null' ? const Icon(Icons.image) : null,
        ),
        title: Text(donorName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories: ${categories.join(', ')}'),
            Text('Contact: $contactNumber'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrganizationProfileScreen()),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/donation_drive_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/donation_drive_model.dart';

class DonationDrivesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DonationDriveListProvider donationDriveProvider =
        Provider.of<DonationDriveListProvider>(context);
    MyAuthProvider authProvider = Provider.of<MyAuthProvider>(context);

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
                donationDriveProvider.searchDonationDrives(value);
              },
            ),
          ),
          // Donation Drives List
          Expanded(
            child: Consumer<DonationDriveListProvider>(
              builder: (context, provider, child) {
                var donationDrives = provider.donationDrives;
                return ListView.builder(
                  itemCount: donationDrives.length,
                  itemBuilder: (context, index) {
                    return DonationDriveItem(
                      donationDrive: donationDrives[index],
                      onEdit: () => _showDonationDriveDialog(
                        context,
                        authProvider,
                        donationDriveProvider,
                        donationDrive: donationDrives[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDonationDriveDialog(
            context, authProvider, donationDriveProvider),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDonationDriveDialog(
      BuildContext context,
      MyAuthProvider authProvider,
      DonationDriveListProvider donationDriveProvider,
      {DonationDrive? donationDrive}) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: donationDrive?.name ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: donationDrive?.description ?? '');
    final TextEditingController startDateController = TextEditingController(
        text: donationDrive?.startDate.toIso8601String() ?? '');
    final TextEditingController endDateController = TextEditingController(
        text: donationDrive?.endDate.toIso8601String() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(donationDrive == null
              ? 'Add Donation Drive'
              : 'Edit Donation Drive'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a start date' : null,
                ),
                TextFormField(
                  controller: endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an end date' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String email = authProvider.userObj!.email!;
                  String? organizationId = await donationDriveProvider
                      .getOrganizationIdByEmail(email);
                  if (organizationId != null) {
                    DonationDrive newDonationDrive = DonationDrive(
                      id: donationDrive?.id,
                      organizationId: organizationId,
                      name: nameController.text,
                      description: descriptionController.text,
                      startDate: DateTime.parse(startDateController.text),
                      endDate: DateTime.parse(endDateController.text),
                      photos: donationDrive?.photos ?? [],
                    );

                    if (donationDrive == null) {
                      donationDriveProvider.addDonationDrive(newDonationDrive);
                    } else {
                      donationDriveProvider.editDonationDrive(newDonationDrive);
                    }

                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text(donationDrive == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }
}

class DonationDriveItem extends StatelessWidget {
  final DonationDrive donationDrive;
  final VoidCallback onEdit;

  DonationDriveItem({required this.donationDrive, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    DonationDriveListProvider donationDriveProvider =
        Provider.of<DonationDriveListProvider>(context);

    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(donationDrive.name),
        subtitle: Text(
            '${donationDrive.startDate.toIso8601String()} - ${donationDrive.endDate.toIso8601String()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                donationDriveProvider.deleteDonationDrive(donationDrive.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

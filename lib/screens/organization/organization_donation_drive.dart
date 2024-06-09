import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/donation_drive_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/donation_drive_model.dart';

class DonationDrivesScreen extends StatelessWidget {
  const DonationDrivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DonationDriveListProvider donationDriveProvider =
        Provider.of<DonationDriveListProvider>(context);
    MyAuthProvider authProvider = Provider.of<MyAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Drives'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by donation drive name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                donationDriveProvider.searchDonationDrives(value);
              },
            ),
          ),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDonationDriveDialog(
      BuildContext context,
      MyAuthProvider authProvider,
      DonationDriveListProvider donationDriveProvider,
      {DonationDrive? donationDrive}) {
    final formKey = GlobalKey<FormState>();
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
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a start date' : null,
                ),
                TextFormField(
                  controller: endDateController,
                  decoration: const InputDecoration(labelText: 'End Date'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an end date' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
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

  const DonationDriveItem(
      {super.key, required this.donationDrive, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    DonationDriveListProvider donationDriveProvider =
        Provider.of<DonationDriveListProvider>(context);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(donationDrive.name),
        subtitle: Text(
            '${donationDrive.startDate.toIso8601String()} - ${donationDrive.endDate.toIso8601String()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
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

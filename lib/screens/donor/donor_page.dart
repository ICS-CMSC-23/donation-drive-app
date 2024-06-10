import 'dart:ui';
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/organization_provider.dart';
import 'donor_profile.dart';
import 'donate_form.dart';
import '../../models/organization_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donationpage.dart';

class DonorPage extends StatelessWidget {
  const DonorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Homepage"),
      ),
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:
                Provider.of<OrganizationListProvider>(context).organizations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error loading organizations"));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No organizations found"));
              } else {
                var organizations = snapshot.data!.docs.map((doc) {
                  return Organization.fromJson(
                    doc.data() as Map<String, dynamic>,
                  );
                }).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: organizations.map((org) {
                        return _buildOrganizationCard(
                          context,
                          org,
                          () => approveOrganization(context, org),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void approveOrganization(BuildContext context, Organization organization) {
    // Navigate to DonationFormPage with the selected organization
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonationFormPage(organization: organization),
      ),
    );

    // Show snackbar message for approval
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Organization chosen"),
      ),
    );
  }

  Widget _buildOrganizationCard(
      BuildContext context, Organization organization, VoidCallback onApprove) {
    return GestureDetector(
      onTap: () {
        _showOverlay(context, organization, onApprove);
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                organization.organizationName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                organization.about ?? "No description available",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Row(mainAxisAlignment: MainAxisAlignment.spaceAround),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DonorProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('View Donation History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DonationHistoryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              await authProvider.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showOverlay(
      BuildContext context, Organization organization, VoidCallback onApprove) {
    OverlayEntry? overlay;

    // Create a controller for the animation
    AnimationController? controller;

    // Define the animation
    Animation<double>? animation;

    // Function to remove overlay and dispose animation controller
    void removeOverlayAndDispose() {
      overlay?.remove();
      if (controller != null) {
        controller.dispose();
      }
    }

    controller = AnimationController(
      duration: const Duration(milliseconds: 300), // Adjust duration as needed
      vsync: Navigator.of(context),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    // Start the animation
    controller.forward();

    overlay = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return Opacity(
            opacity: animation!.value,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    controller!.reverse();
                  },
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .75,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            organization.organizationName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          _buildDetailBox(
                              'Address', organization.addresses.join(", ")),
                          const SizedBox(height: 10),
                          _buildDetailBox(
                              'Contact Number', organization.contactNo),
                          const SizedBox(height: 10),
                          _buildDetailBox('About',
                              organization.about ?? "No description available"),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: organization.isOpen
                                ? () {
                                    onApprove();
                                    removeOverlayAndDispose();
                                  }
                                : null,
                            child: const Text("Select this organization"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(overlay);

    // Add listener to dispose the animation controller when the overlay is removed
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        removeOverlayAndDispose();
      }
    });
  }

  Widget _buildDetailBox(String title, String detail) {
    return SizedBox(
      width: 200, // Set a fixed width for each detail box
      height: 100, // Set a fixed height for each detail box
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              detail,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

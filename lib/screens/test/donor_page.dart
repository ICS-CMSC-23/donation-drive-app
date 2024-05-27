import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/donor_model.dart';
import '../../providers/donor_provider.dart';

class DonorPage extends StatefulWidget {
  const DonorPage({super.key});

  @override
  State<DonorPage> createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> donorsStream =
        context.watch<DonorListProvider>().donors;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor"),
      ),
      body: StreamBuilder(
        stream: donorsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Donors Found"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              Donor donor = Donor.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              return Column(children: <Widget>[
                Text(donor.name),
                Text(donor.username),
                Text(donor.password),
                Column(
                    children: donor.addresses
                        .map((address) => Text(address))
                        .toList()),
                Text(donor.contactNo)
              ]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}

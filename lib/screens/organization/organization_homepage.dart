import 'package:flutter/material.dart';

class OrganizationHomepage extends StatelessWidget {
  const OrganizationHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Homepage")),
        body: const Text("List of donations"));
  }
}

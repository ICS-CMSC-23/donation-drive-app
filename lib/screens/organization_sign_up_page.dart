import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/organization_provider.dart';
import '../models/organization_model.dart';

class OrganizationSignUpPage extends StatefulWidget {
  const OrganizationSignUpPage({Key? key}) : super(key: key);

  @override
  State<OrganizationSignUpPage> createState() => _OrganizationSignUpPageState();
}

class _OrganizationSignUpPageState extends State<OrganizationSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<TextEditingController> addressesController = [TextEditingController()];
  TextEditingController contactNoController = TextEditingController();
  TextEditingController organizationNameController = TextEditingController();
  List<TextEditingController> proofsOfLegitimacyController = [
    TextEditingController()
  ];

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    if (pickedFile == null) return;

    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);

    final fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }

  @override
  Widget build(BuildContext context) {
    final firstName = TextFormField(
        controller: firstNameController,
        decoration: const InputDecoration(
          labelText: "First name",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'First name is required';
          }
          return null;
        });

    final lastName = TextFormField(
        controller: lastNameController,
        decoration: const InputDecoration(
          labelText: "Last name",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Last name is required';
          }
          return null;
        });

    final username = TextFormField(
        controller: usernameController,
        decoration: const InputDecoration(
          labelText: "Username",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Username is required';
          }
          if (!EmailValidator.validate(value)) {
            return 'Invalid username';
          }
          return null;
        });

    final password = TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        });

    final organizationName = TextFormField(
      controller: organizationNameController,
      decoration: const InputDecoration(
        labelText: 'Name of Organization',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Organization name is required';
        }
        return null;
      },
    );

    final signUpButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll<Color>(
            Color.fromRGBO(255, 63, 64, 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(
                color: Color.fromRGBO(255, 63, 64, 1), width: 2.0),
          ),
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await context
              .read<MyAuthProvider>()
              .signUp(usernameController.text, passwordController.text);

          int organizationCount = await context
              .read<OrganizationListProvider>()
              .getOrganizationCount();

          // Upload file and get URL
          final proofUrl = await uploadFile();

          context.read<OrganizationListProvider>().addOrganization(Organization(
                userId: organizationCount,
                name: '${firstNameController.text} ${lastNameController.text}',
                username: usernameController.text,
                password: passwordController.text,
                addresses: addressesController.map((c) => c.text).toList(),
                contactNo: contactNoController.text,
                organizationName: organizationNameController.text,
                proofsOfLegitimacy: proofUrl != null ? [proofUrl] : [],
              ));
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: const Text('SIGN UP', style: TextStyle(color: Colors.white)),
    );

    final backButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(
                color: Color.fromRGBO(255, 63, 64, 1), width: 2.0),
          ),
        ),
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
      child: const Text('BACK',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(255, 63, 64, 1))),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(48, 61, 78, 1),
        title: const Text(
          "Organization Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, // Bold text
            color: Colors.white, // White text color
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(48, 61, 78, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      firstName,
                      const SizedBox(height: 10),
                      lastName,
                      const SizedBox(height: 10),
                      username,
                      const SizedBox(height: 10),
                      password,
                      const SizedBox(height: 10),
                      for (var i = 0; i < addressesController.length; i++)
                        Column(children: [
                          Row(children: [
                            Expanded(
                                child: TextFormField(
                              controller: addressesController[i],
                              decoration: InputDecoration(
                                labelText: 'Address ${i + 1}',
                                border: const OutlineInputBorder(),
                              ),
                            )),
                            const SizedBox(height: 10),
                            IconButton(
                                color: const Color.fromRGBO(255, 63, 64, 1),
                                icon: const Icon(Icons.playlist_remove_rounded),
                                onPressed: () {
                                  setState(() {
                                    addressesController.removeAt(i);
                                  });
                                })
                          ]),
                          const SizedBox(height: 10),
                        ]),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Color.fromRGBO(255, 63, 64,
                                      1)), // Set the icon/text color
                          side: const MaterialStatePropertyAll<BorderSide>(
                              BorderSide(
                                  color: Color.fromRGBO(255, 63, 64, 1),
                                  width: 2.0) // Outline color
                              ),
                          shape:
                              MaterialStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            addressesController.add(TextEditingController());
                          });
                        },
                        child: const Text('ADD ADDRESS',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      organizationName,
                      const SizedBox(height: 10),
                      for (var i = 0;
                          i < proofsOfLegitimacyController.length;
                          i++)
                        Row(children: [
                          Container(
                            width: 120,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                  Color.fromRGBO(48, 61, 78, 1),
                                ), // Set the icon/text color
                                side:
                                    const MaterialStatePropertyAll<BorderSide>(
                                        BorderSide(
                                  color: Color.fromRGBO(48, 61, 78, 1),
                                ) // Outline color
                                        ),
                                shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                padding:
                                    const MaterialStatePropertyAll<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 0), // Adjust padding here
                                ),
                              ),
                              onPressed: selectFile,
                              child: const Text('BROWSE FILES',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(pickedFile?.name ?? 'No file selected'),
                          IconButton(
                              color: const Color.fromRGBO(48, 61, 78, 1),
                              icon: const Icon(Icons.playlist_remove_rounded),
                              onPressed: () {
                                setState(() {
                                  proofsOfLegitimacyController.removeAt(i);
                                });
                              })
                        ]),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              const MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(48, 61, 78, 1),
                          ), // Set the icon/text color
                          side: const MaterialStatePropertyAll<BorderSide>(
                              BorderSide(
                                  color: Color.fromRGBO(48, 61, 78, 1),
                                  width: 2.0) // Outline color
                              ),
                          shape:
                              MaterialStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            proofsOfLegitimacyController
                                .add(TextEditingController());
                          });
                        },
                        child: const Text('ADD PROOF OF LEGITIMACY',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: backButton),
                          const SizedBox(width: 10),
                          Expanded(child: signUpButton),
                        ],
                      ),
                    ],
                  ),
                ))),
          ),
        ),
      ),
    );
  }
}

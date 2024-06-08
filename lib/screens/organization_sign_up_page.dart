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

    final proofsOfLegitimacy =
        IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {});

    final signUpButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(
              Color.fromARGB(255, 38, 32, 69)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(
                  color: Color.fromARGB(255, 38, 32, 69), width: 2.0),
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

            context
                .read<OrganizationListProvider>()
                .addOrganization(Organization(
                  userId: organizationCount,
                  name:
                      '${firstNameController.text} ${lastNameController.text}',
                  username: usernameController.text,
                  password: passwordController.text,
                  addresses: addressesController.map((c) => c.text).toList(),
                  contactNo: contactNoController.text,
                  organizationName: organizationNameController.text,
                  proofsOfLegitimacy:
                      proofsOfLegitimacyController.map((c) => c.text).toList(),
                ));
            if (context.mounted) Navigator.pop(context);
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(
                  color: Color.fromARGB(255, 38, 32, 69), width: 2.0),
            ),
          ),
        ),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back',
            style: TextStyle(color: Color.fromARGB(255, 38, 32, 69))),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Organization Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  firstName,
                  lastName,
                  username,
                  password,
                  for (var i = 0; i < addressesController.length; i++)
                    Row(children: [
                      Expanded(
                          child: TextFormField(
                        controller: addressesController[i],
                        decoration: InputDecoration(
                          labelText: 'Address ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      )),
                      IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              addressesController.removeAt(i);
                            });
                          })
                    ]),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        addressesController.add(TextEditingController());
                      });
                    },
                    child: const Text("Add address"),
                  ),
                  organizationName,
                  for (var i = 0; i < proofsOfLegitimacyController.length; i++)
                    Row(children: [
                      Expanded(
                          child: TextFormField(
                        controller: proofsOfLegitimacyController[i],
                        decoration: InputDecoration(
                          labelText: 'Proof ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      )),
                      IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              proofsOfLegitimacyController.removeAt(i);
                            });
                          })
                    ]),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        proofsOfLegitimacyController
                            .add(TextEditingController());
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                  signUpButton,
                  backButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

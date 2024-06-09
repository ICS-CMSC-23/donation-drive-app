import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../providers/organization_provider.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'donor/donor_page.dart';
import 'organization/organization_page.dart';
import '../models/organization_model.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      key: const Key('emailField'),
      controller: emailController,
      decoration: const InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email address is required';
        }
        if (!EmailValidator.validate(value)) {
          return 'Invalid email address';
        }
        return null;
      },
    );

    final password = TextFormField(
      key: const Key('pwField'),
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
      },
    );

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color.fromARGB(255, 38, 32, 69),
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            String? result = await context.read<MyAuthProvider>().signIn(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

            if (result == 'donor') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DonorPage()),
              );
            } else if (result == 'organization') {
              Organization? orgToSign = await context
                  .read<OrganizationListProvider>()
                  .getOrganizationByUsername(emailController.text);
              if (!orgToSign!.isApproved) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(content: Text("Not yet approved"));
                    });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrganizationPage()),
                );
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: Text(result ?? 'Something went wrong.'));
                },
              );
            }
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final signUpButton = Padding(
      key: const Key('signUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(
                color: Color.fromARGB(255, 38, 32, 69),
                width: 2.0,
              ),
            ),
          ),
        ),
        onPressed: () async {
          Navigator.of(context).pushNamed('/orgquestion');
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(color: Color.fromARGB(255, 38, 32, 69)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              const Text(
                "Sign in",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              email,
              const SizedBox(height: 20),
              password,
              const SizedBox(height: 20),
              loginButton,
              signUpButton,
            ],
          ),
        ),
      ),
    );
  }
}

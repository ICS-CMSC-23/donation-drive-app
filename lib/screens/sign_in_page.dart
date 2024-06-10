import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'donor/donor_page.dart';
import '../providers/organization_provider.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
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
          suffixIcon: Icon(Icons.email),
          errorStyle: TextStyle(color: Colors.redAccent)),
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
          suffixIcon: Icon(Icons.lock),
          errorStyle: TextStyle(color: Colors.redAccent)),
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
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(
              Color.fromRGBO(255, 63, 64, 1)),
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 16)), //button height
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
                MaterialPageRoute(builder: (context) => const DonorPage()),
              );
            } else if (result == 'organization') {
              Organization? orgToSign = await context
                  .read<OrganizationListProvider>()
                  .getOrganizationByUsername(emailController.text);
              if (!orgToSign!.isApproved) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                          content: Text("Not yet approved"));
                    });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrganizationPage()),
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
        child: const Text('LOGIN',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
      ),
    );

    // final signUpButton = Padding(
    //   key: const Key('signUpButton'),
    //   padding: const EdgeInsets.symmetric(vertical: 16.0),
    //   child: ElevatedButton(
    //     style: ButtonStyle(
    //       backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
    //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //         RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(18.0),
    //           side: const BorderSide(
    //               color: Color.fromARGB(255, 38, 32, 69), width: 2.0),
    //         ),
    //       ),
    //     ),
    //     onPressed: () async {
    //       Navigator.of(context).pushNamed('/orgquestion');
    //     },
    //     child: const Text('Sign Up',
    //         style: TextStyle(color: Color.fromARGB(255, 38, 32, 69))),
    //   ),
    // );

    return Scaffold(
        backgroundColor: const Color.fromRGBO(48, 61, 78, 1),
        body: Center(
            child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: _formKey,
                              child: ListView(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(20),
                                children: <Widget>[
                                  const Text(
                                    "Welcome!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    "Login to continue",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  email,
                                  const SizedBox(height: 10),
                                  password,
                                  const SizedBox(height: 10),
                                  loginButton,
                                  // signUpButton,
                                ],
                              ),
                            ),
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/orgquestion');
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'New user? ',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(255, 63, 64, 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]))));
  }
}

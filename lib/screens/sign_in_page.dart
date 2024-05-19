import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final email = TextFormField(
      key: const Key('emailField'),
      controller: emailController,
      decoration: const InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.email),
        errorStyle: TextStyle(color: Colors.redAccent),
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
        suffixIcon: Icon(Icons.lock),
        errorStyle: TextStyle(color: Colors.redAccent),
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
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(
              Color.fromRGBO(255, 63, 64, 1)),
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 16)), //button height
        ),
        onPressed: () {
          // Check if the form is valid
          if (_formKey.currentState!.validate()) {
            // If the form is valid, proceed with signing in
            context.read<MyAuthProvider>().signIn(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
          }
          // If the form is not valid, the validator messages will appear
        },
        child: const Text('LOGIN',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
      ),
    );

    //unused
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap:
                            true, // Make ListView only occupy needed space
                        children: <Widget>[
                          const Text(
                            "Welcome!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
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
                          loginButton,
                        ],
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

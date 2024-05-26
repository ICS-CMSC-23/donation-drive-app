import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<TextEditingController> addressesController = [TextEditingController()];
  TextEditingController contactNoController = TextEditingController();

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

    final email = TextFormField(
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
                .signUp(emailController.text, passwordController.text);
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
          "Sign Up",
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
                  email,
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
                    child: const Icon(Icons.add),
                  ),
                  signUpButton,
                  backButton
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrganizationSignUpPage extends StatefulWidget {
  const OrganizationSignUpPage({Key? key}) : super(key: key);

  @override
  State<OrganizationSignUpPage> createState() => _OrganizationSignUpPageState();
}

class _OrganizationSignUpPageState extends State<OrganizationSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<TextEditingController> addressesController = [TextEditingController()];
  TextEditingController contactNoController = TextEditingController();
  TextEditingController orgNameController = TextEditingController();
  TextEditingController orgProofController = TextEditingController();

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

    final email = TextFormField(
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

    final orgName = TextFormField(
      controller: orgNameController,
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

    final orgProof =
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
                .signUp(emailController.text, passwordController.text);
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
                  email,
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
                  orgName,
                  orgProof,
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

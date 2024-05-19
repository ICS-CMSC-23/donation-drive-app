import 'package:flutter/material.dart';

class OrganizationQuestionPage extends StatelessWidget {
  const OrganizationQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(48, 61, 78, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Card(
              color: Colors.grey[100],
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign up as an organization?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor:
                                const Color.fromRGBO(255, 63, 64, 1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/orgsignup');
                          },
                          child: const Text('YES',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color.fromRGBO(255, 63, 64, 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: const Text('NO',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

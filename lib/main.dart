import 'package:flutter/material.dart';
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/organization_question_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo with Auth',
      initialRoute: '/signin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/orgsignup': (context) => const OrganizationSignUpPage(),
        '/orgquestion': (context) => const OrganizationQuestionPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/organization_sign_up_page.dart';
import 'screens/organization_question_page.dart';
import 'screens/organization/organization_homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/donor_provider.dart';
import 'providers/organization_provider.dart';
import 'screens/test/donor_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => MyAuthProvider())),
        ChangeNotifierProvider(create: ((context) => DonorListProvider())),
        ChangeNotifierProvider(
            create: ((context) => OrganizationListProvider()))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo with Auth',
      initialRoute: '/orgsignup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/orgsignup': (context) => const OrganizationSignUpPage(),
        '/orgquestion': (context) => const OrganizationQuestionPage(),
        '/orghomepage': (context) => const OrganizationHomepage(),
        '/donorpage': (context) => const DonorPage()
      },
    );
  }
}

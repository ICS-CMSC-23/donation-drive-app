import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/organization_sign_up_page.dart';
import 'screens/organization_question_page.dart';
import 'screens/organization/organization_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/donor_provider.dart';
import 'providers/organization_provider.dart';
import 'providers/donation_provider.dart';
import 'providers/donation_drive_provider.dart';
import 'screens/donor/donor_page.dart';

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
            create: ((context) => OrganizationListProvider())),
        ChangeNotifierProvider(create: ((context) => DonationListProvider())),
        ChangeNotifierProvider(
          create: ((context) {
            final myAuthProvider =
                Provider.of<MyAuthProvider>(context, listen: false);
            final organizationListProvider =
                Provider.of<OrganizationListProvider>(context, listen: false);
            return DonationDriveListProvider(
                authProvider: myAuthProvider,
                organizationListProvider: organizationListProvider);
          }),
        )
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
      initialRoute: '/signin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/orgsignup': (context) => const OrganizationSignUpPage(),
        '/orgquestion': (context) => const OrganizationQuestionPage(),
        '/orghomepage': (context) => const OrganizationPage(),
        '/donorpage': (context) => const DonorPage(),
      },
    );
  }
}

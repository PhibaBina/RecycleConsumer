import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:recycle_bazaar_consumer/screens/homedashboard.dart';
import 'package:recycle_bazaar_consumer/screens/login.dart';
import 'package:recycle_bazaar_consumer/screens/registration.dart';
import 'package:recycle_bazaar_consumer/firebase_options.dart';
import 'package:recycle_bazaar_consumer/screens/scrap_collection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is currently logged in
    final User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Recycle Bazaar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      // If user logged in, go to dashboard; else go to login screen
      home: user != null ? const HomeDashboard() : const LoginScreen(),
    );
  }
}

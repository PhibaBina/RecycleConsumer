import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recycle_bazaar_consumer/screens/homedashboard.dart';
import 'package:recycle_bazaar_consumer/screens/login.dart';
import 'package:recycle_bazaar_consumer/screens/registration.dart';
import 'firebase_options.dart';

import 'screens/scrap_collection.dart'; // Import your Scrap Collection Form screen

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
    return MaterialApp(
      title: 'Recycle Bazzar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const HomeDashboard(),
     // home: const LoginScreen(), // Login
    );
  }
}

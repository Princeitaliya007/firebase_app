import 'package:firebase_app/screens/dashboard_page.dart';
import 'package:firebase_app/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      routes: {
        '/': (context) => HomePage(),
        'dashboard': (context) => DashBoard(),
      },
    ),
  );
}

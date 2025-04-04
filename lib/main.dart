import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,     
      title: 'GSB MedTracker',
      theme: ThemeData(
        primarySwatch: Colors.blue  ,
      ),
      home: LoginPage(), 
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
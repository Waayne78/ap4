import 'package:flutter/material.dart';
import 'package:ap4/login_page.dart';
import 'package:ap4/home_page.dart';
import 'package:ap4/signup_page.dart';
import 'package:ap4/catalogue_page.dart';
import 'package:ap4/order_page.dart';
import 'package:ap4/profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4F6AF6),
        scaffoldBackgroundColor: Color(0xFFF8FAFF),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF2D3142),
          elevation: 0,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/signup': (context) => SignupPage(),
        '/catalogue': (context) => CataloguePage(),
        '/order': (context) => OrderPage(panier: []),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
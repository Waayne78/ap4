import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainNavigationPage extends StatelessWidget {
  final String userId;

  const MainNavigationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Affiche uniquement la HomePage (ou ProfilePage si tu préfères)
    return HomePage(userId: userId);
    // Pour afficher le profil à la place, utilise :
    // return ProfilePage(userId: userId);
  }
}
import 'package:ap4/main_navigation_page.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:ap4/widgets/custom_textfield.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre
                Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),
                // Champ nom
                CustomTextField(
                  label: 'Nom',
                  icon: Icons.person,
                  controller: nameController,
                ),
                SizedBox(height: 20),
                // Champ email
                CustomTextField(
                  label: 'Email',
                  icon: Icons.email,
                  controller: emailController,
                ),
                SizedBox(height: 20),
                // Champ mot de passe
                CustomTextField(
                  label: 'Mot de passe',
                  icon: Icons.lock,
                  isPassword: true,
                  controller: passwordController,
                ),
                SizedBox(height: 30),
                // Bouton d'inscription
                ElevatedButton(
                  onPressed: () {
                    // Simuler une inscription réussie
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainNavigationPage()), // Redirige vers la page parente
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Lien vers la page de connexion
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Déjà inscrit ? Connectez-vous',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

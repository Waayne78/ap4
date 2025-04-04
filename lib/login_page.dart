import 'package:ap4/main_navigation_page.dart';
import 'package:flutter/material.dart';
// import 'package:ap4/widgets/custom_textfield.dart';
import 'package:ap4/widgets/custom_textfield.dart';
import 'signup_page.dart';
import 'profile_page.dart';

class LoginPage extends StatelessWidget {
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
                  'Connexion',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),
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
                // Bouton de connexion
                ElevatedButton(
                  onPressed: () {
                    // Simuler une connexion réussie
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
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Lien vers la page d'inscription
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    'Pas de compte ? Inscrivez-vous',
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

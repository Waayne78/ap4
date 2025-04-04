import 'package:flutter/material.dart';
import 'package:ap4/models/medicament.dart'; // Assurez-vous d'avoir ce modèle
import 'catalogue_page.dart'; // Page à créer
import 'order_page.dart'; // Page à créer
import 'profile_page.dart'; 

class HomePage extends StatelessWidget {
  // Données simulées
  final List<Medicament> medicamentsPopulaires = [
    Medicament(id: '1', nom: 'Paracétamol', prix: 5.99, stock: 100),
    Medicament(id: '2', nom: 'Ibuprofène', prix: 7.99, stock: 50),
    Medicament(id: '3', nom: 'Aspirine', prix: 4.99, stock: 75),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Simuler une déconnexion
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section : Tableau de bord
            Text(
              'Tableau de bord',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                // Carte : Commandes en cours
                _buildDashboardCard(
                  title: 'Commandes en cours',
                  value: '3',
                  icon: Icons.shopping_cart,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 16),
                // Carte : Médicaments en stock
                _buildDashboardCard(
                  title: 'Médicaments en stock',
                  value: '225',
                  icon: Icons.medical_services,
                  color: Colors.greenAccent,
                ),
              ],
            ),
            SizedBox(height: 30),

            // Section : Médicaments populaires
            Text(
              'Médicaments populaires',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...medicamentsPopulaires.map((medicament) => _buildMedicamentCard(medicament)).toList(),
            SizedBox(height: 30),

            // Section : Navigation rapide
            Text(
              'Navigation rapide',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  icon: Icons.medical_services,
                  label: 'Catalogue',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CataloguePage()),
                    );
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.shopping_cart,
                  label: 'Commandes',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderPage(panier: [],)),
                    );
                  },
                ),
               
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour créer une carte du tableau de bord
  Widget _buildDashboardCard({required String title, required String value, required IconData icon, required Color color}) {
    return Expanded(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour créer une carte de médicament
  Widget _buildMedicamentCard(Medicament medicament) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.medical_services, color: Colors.blueAccent),
        title: Text(medicament.nom, style: TextStyle(fontSize: 18)),
        subtitle: Text('${medicament.prix} € - Stock: ${medicament.stock}'),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {
            // Ajouter au panier
          },
        ),
      ),
    );
  }

  // Widget pour créer un bouton de navigation rapide
  Widget _buildQuickActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40, color: Colors.blueAccent),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
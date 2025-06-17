import 'package:flutter/material.dart';
import 'package:ap4/models/medicament.dart'; // Assurez-vous d'avoir ce modèle

class OrderPage extends StatelessWidget {
  final List<Medicament> panier;

  const OrderPage({super.key, required this.panier});

  @override
  Widget build(BuildContext context) {
    double total = panier.fold(0, (sum, medicament) => sum + medicament.prix);

    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: Column(
        children: [
          // Liste des médicaments dans le panier
          Expanded(
            child: ListView.builder(
              itemCount: panier.length,
              itemBuilder: (context, index) {
                final medicament = panier[index];
                return ListTile(
                  title: Text(medicament.nom),
                  subtitle: Text('${medicament.prix.toString()} €'), // Convertir en chaîne
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () {
                      // Retirer du panier
                    },
                  ),
                );
              },
            ),
          ),
          // Total et bouton de validation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: ${total.toStringAsFixed(2)} €',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Valider la commande
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Commande validée !')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Valider la commande',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
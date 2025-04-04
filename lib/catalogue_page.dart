import 'package:flutter/material.dart';
import 'package:ap4/models/medicament.dart';
import 'package:ap4/order_page.dart'; // Assurez-vous d'avoir ce modèle

class CataloguePage extends StatefulWidget {
  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  // Données simulées
  final List<Medicament> medicaments = [
    Medicament(id: '1', nom: 'Paracétamol', prix: 5.99, stock: 100),
    Medicament(id: '2', nom: 'Ibuprofène', prix: 7.99, stock: 50),
    Medicament(id: '3', nom: 'Aspirine', prix: 4.99, stock: 75),
    Medicament(id: '4', nom: 'Doliprane', prix: 6.99, stock: 60),
  ];

  List<Medicament> panier = []; // Panier pour stocker les médicaments sélectionnés

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogue des médicaments'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Naviguer vers la page de commande
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderPage(panier: panier),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un médicament...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // Filtrer les médicaments en fonction de la recherche
                setState(() {
                  // Implémentez la logique de filtrage ici
                });
              },
            ),
          ),
          // Liste des médicaments
          Expanded(
            child: ListView.builder(
              itemCount: medicaments.length,
              itemBuilder: (context, index) {
                final medicament = medicaments[index];
                return ListTile(
                  title: Text(medicament.nom),
                  subtitle: Text('${medicament.prix} € - Stock: ${medicament.stock}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      setState(() {
                        panier.add(medicament); // Ajouter au panier
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${medicament.nom} ajouté au panier')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
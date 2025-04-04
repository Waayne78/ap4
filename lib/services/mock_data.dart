import '../models/medicament.dart';
import '../models/commande.dart';

// Données simulées pour les médicaments
List<Medicament> mockMedicaments = [
  Medicament(id: '1', nom: 'Paracétamol', prix: 5.99, stock: 100),
  Medicament(id: '2', nom: 'Ibuprofène', prix: 7.99, stock: 50),
];

// Données simulées pour les commandes
List<Commande> mockCommandes = [
  Commande(
    id: '1',
    medicaments: [mockMedicaments[0]],
    date: DateTime.now(),
    statut: 'En attente',
  ),
];
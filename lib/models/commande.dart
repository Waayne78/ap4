import 'package:ap4/models/medicament.dart';

class Commande {
  final String id;
  final List<Medicament> medicaments;
  final DateTime date;
  final String statut; // Ex: "En attente", "Expédiée", "Livrée"

  Commande({
    required this.id,
    required this.medicaments,
    required this.date,
    required this.statut,
  });
}
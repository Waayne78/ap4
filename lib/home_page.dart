import 'package:flutter/material.dart';
import 'package:ap4/models/medicament.dart'; // Assurez-vous d'avoir ce modèle
import 'catalogue_page.dart'; // Page à créer
import 'order_page.dart'; // Page à créer
import 'profile_page.dart'; 

// Ajout d'une classe pour représenter une commande
class Commande {
  final String id;
  final String clientNom;
  final DateTime date;
  final String status;
  final double montant;
  final List<Medicament> medicaments;

  Commande({
    required this.id,
    required this.clientNom,
    required this.date,
    required this.status,
    required this.montant,
    required this.medicaments,
  });
}

class HomePage extends StatelessWidget {
  // Données simulées pour les commandes
  final List<Commande> commandes = [
    Commande(
      id: "CMD001",
      clientNom: "Jean Dupont",
      date: DateTime.now().subtract(Duration(hours: 2)),
      status: "En cours",
      montant: 45.98,
      medicaments: [
        Medicament(id: '1', nom: 'Paracétamol', prix: 5.99, stock: 100),
        Medicament(id: '2', nom: 'Ibuprofène', prix: 7.99, stock: 50),
      ],
    ),
    Commande(
      id: "CMD002",
      clientNom: "Marie Martin",
      date: DateTime.now().subtract(Duration(hours: 5)),
      status: "En préparation",
      montant: 23.97,
      medicaments: [
        Medicament(id: '3', nom: 'Aspirine', prix: 4.99, stock: 75),
      ],
    ),
    Commande(
      id: "CMD003",
      clientNom: "Pierre Durand",
      date: DateTime.now().subtract(Duration(days: 1)),
      status: "Livré",
      montant: 89.95,
      medicaments: [
        Medicament(id: '1', nom: 'Paracétamol', prix: 5.99, stock: 100),
        Medicament(id: '2', nom: 'Ibuprofène', prix: 7.99, stock: 50),
        Medicament(id: '3', nom: 'Aspirine', prix: 4.99, stock: 75),
      ],
    ),
  ];

  void _handleLogout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF8FAFF),
      child: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF4F6AF6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.medical_services_outlined,
                              color: Color(0xFF4F6AF6),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Suivi des Commandes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              Text(
                                'Pharmacie du Centre',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF2D3142).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildNavbarButton(
                            icon: Icons.notifications_outlined,
                            badgeCount: '3',
                            onPressed: () {},
                          ),
                          SizedBox(width: 8),
                          _buildNavbarButton(
                            icon: Icons.person_outline,
                            onPressed: () {},
                          ),
                          SizedBox(width: 8),
                          _buildNavbarButton(
                            icon: Icons.logout_outlined,
                            onPressed: () => _handleLogout(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  _buildStatisticsHeader(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Commandes récentes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('Voir tout'),
                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFF4F6AF6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: commandes.isEmpty
                        ? _buildEmptyState()
                        : _buildCommandesList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F6AF6), Color(0xFF6B7FF7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF4F6AF6).withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Aujourd'hui", "12", Icons.calendar_today),
                Container(height: 50, width: 1, color: Colors.white.withOpacity(0.3)),
                _buildStatItem("En cours", "5", Icons.pending_actions),
                Container(height: 50, width: 1, color: Colors.white.withOpacity(0.3)),
                _buildStatItem("Terminées", "7", Icons.check_circle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCommandesList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: commandes.length,
      itemBuilder: (context, index) {
        final commande = commandes[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: _getStatusIcon(commande.status),
              title: Text(
                'Commande #${commande.id}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3142),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    commande.clientNom,
                    style: TextStyle(
                      color: Color(0xFF2D3142).withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '${commande.montant.toStringAsFixed(2)} €',
                    style: TextStyle(
                      color: Color(0xFF4F6AF6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Détails de la commande',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      SizedBox(height: 12),
                      ...commande.medicaments.map((med) => Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              med.nom,
                              style: TextStyle(color: Color(0xFF2D3142)),
                            ),
                            Text(
                              '${med.prix} €',
                              style: TextStyle(
                                color: Color(0xFF4F6AF6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            'Détails',
                            Icons.info_outline,
                            Color(0xFF4F6AF6),
                            () {},
                          ),
                          _buildActionButton(
                            'Modifier',
                            Icons.edit_outlined,
                            Color(0xFFFFA726),
                            () {},
                          ),
                          _buildActionButton(
                            'Terminer',
                            Icons.check_circle_outline,
                            Color(0xFF66BB6A),
                            () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 18),
        label: Text(
          label,
          style: TextStyle(color: color),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    IconData icon;
    Color color;
    
    switch (status.toLowerCase()) {
      case 'en cours':
        icon = Icons.hourglass_empty;
        color = Color(0xFFFFA726);
        break;
      case 'en préparation':
        icon = Icons.pending_outlined;
        color = Color(0xFF4F6AF6);
        break;
      case 'livré':
        icon = Icons.check_circle_outline;
        color = Color(0xFF66BB6A);
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildNavbarButton({
    required IconData icon,
    String? badgeCount,
    required VoidCallback onPressed,
  }) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFF1F4FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            color: Color(0xFF2D3142),
            iconSize: 20,
            padding: EdgeInsets.zero,
          ),
        ),
        if (badgeCount != null)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFFFF5757),
                shape: BoxShape.circle,
              ),
              child: Text(
                badgeCount,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/medicine.png',
            height: 150,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          Text(
            'Aucune commande en cours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3142),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Les nouvelles commandes apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2D3142).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
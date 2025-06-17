import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ap4/services/order_service.dart';

class OrderDetailsPage extends StatefulWidget {
  // CORRECTION 1: Accepter une commande potentiellement nulle
  final Map<String, dynamic>? order;

  // CORRECTION 2: Mettre à jour le constructeur (supprimer 'required')
  const OrderDetailsPage({Key? key, this.order}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final OrderService _orderService = OrderService();
  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    final int orderId = _safeGetInt(widget.order, 'id', 0);
    _detailsFuture = _orderService.getFullOrderDetails(orderId);
  }

  String _formatDate(String? dateStr, {String format = 'dd/MM/yyyy HH:mm'}) {
    if (dateStr == null || dateStr.isEmpty) return 'Date inconnue';
    try {
      final DateTime date = DateTime.parse(dateStr).toLocal();
      return DateFormat(format).format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Détails Commande')),
        body: const Center(
          child: Text(
            'Aucune commande sélectionnée.\n(Revenez à la liste des commandes)',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final String orderId = _safeGetInt(widget.order, 'id', 0).toString();
    final String status = _safeGetString(widget.order, 'status', 'Inconnu');
    final String dateCommande = _formatDate(
        _safeGetString(widget.order, 'date_commande', ''),
        format: 'dd/MM/yyyy');
    final double totalAmount =
        _safeGetDouble(widget.order, 'montant_total', 0.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails Commande #$orderId'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Erreur de chargement: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun détail trouvé.'));
          }

          final List<dynamic> items = snapshot.data!['items'] ?? [];
          final List<dynamic> history = snapshot.data!['history'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(dateCommande, status, totalAmount),
                const SizedBox(height: 24),
                _buildSectionTitle('Articles'),
                _buildItemsList(items),
                const SizedBox(height: 24),
                _buildSectionTitle('Historique'),
                _buildHistoryList(history),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSummaryCard(String date, String status, double total) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow('Date', date),
            _buildSummaryRow('Statut', status,
                valueColor: Colors.blue.shade700),
            const Divider(height: 20),
            _buildSummaryRow(
              'Total',
              '${total.toStringAsFixed(2)} €',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {Color? valueColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(List<dynamic> items) {
    if (items.isEmpty) {
      return const Card(
          child: ListTile(title: Text('Aucun article dans cette commande.')));
    }
    return Card(
      elevation: 2,
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index] as Map<String, dynamic>;
          final String medName =
              _safeGetString(item, 'nom_medicament', 'Inconnu');
          final int quantity = _safeGetInt(item, 'quantite', 0);
          final double price = _safeGetDouble(item, 'prix_unitaire', 0.0);
          return ListTile(
            title: Text(medName),
            subtitle: Text('Quantité : $quantity'),
            trailing: Text('${(price * quantity).toStringAsFixed(2)} €'),
          );
        }),
      ),
    );
  }

  Widget _buildHistoryList(List<dynamic> history) {
    if (history.isEmpty) {
      return const Card(
          child: ListTile(title: Text('Aucun historique de statut.')));
    }
    return Card(
      elevation: 2,
      child: Column(
        children: List.generate(history.length, (index) {
          final event = history[index] as Map<String, dynamic>;
          final String status = _safeGetString(event, 'status', 'Inconnu');
          final String date =
              _formatDate(_safeGetString(event, 'date_update', ''));
          return ListTile(
            leading: const Icon(Icons.circle, size: 12, color: Colors.grey),
            title: Text(status),
            subtitle: Text(date),
          );
        }),
      ),
    );
  }

  // --- Fonctions utilitaires rendues plus robustes ---

  int _safeGetInt(Map<String, dynamic>? map, String key, int defaultValue) {
    if (map == null) return defaultValue; // Gère le cas où la map est null
    try {
      final value = map[key];
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      if (value is double) return value.toInt();
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  double _safeGetDouble(
      Map<String, dynamic>? map, String key, double defaultValue) {
    if (map == null) return defaultValue; // Gère le cas où la map est null
    try {
      final value = map[key];
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  String _safeGetString(
      Map<String, dynamic>? map, String key, String defaultValue) {
    if (map == null) return defaultValue; // Gère le cas où la map est null
    try {
      final value = map[key];
      if (value == null) return defaultValue;
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }
}

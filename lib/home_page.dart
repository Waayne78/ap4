import 'package:flutter/material.dart';
import 'package:ap4/services/auth_service.dart';
import 'package:ap4/order_details_page.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    print('[HomePage] Initialisation avec userId: ${widget.userId}');
    _ordersFuture = _authService.getUserOrders(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Commandes'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/profile',
                  arguments: {'userId': widget.userId});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commandes Récentes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Erreur chargement commandes: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('Aucune commande récente'));
                  }

                  print(
                      'snapshot.data runtimeType: ${snapshot.data.runtimeType}');
                  print('snapshot.data: ${snapshot.data}');

                  // Protection maximale contre les valeurs nulles
                  List<Map<String, dynamic>> orders = [];

                  try {
                    // Vérifier que snapshot.data est bien une liste
                    if (snapshot.data is List) {
                      final rawData = snapshot.data as List;

                      // Filtrer et convertir chaque élément de manière sûre
                      for (var item in rawData) {
                        if (item != null && item is Map) {
                          try {
                            // Conversion sûre en Map<String, dynamic>
                            final orderMap = Map<String, dynamic>.from(item);
                            orders.add(orderMap);
                          } catch (e) {
                            print(
                                '[HomePage] Erreur conversion item: $e pour item: $item');
                            // Continuer avec l'élément suivant
                          }
                        }
                      }
                    } else {
                      print(
                          '[HomePage] snapshot.data n\'est pas une liste: ${snapshot.data.runtimeType}');
                      return Center(
                          child: Text(
                              'Format de données invalide reçu du serveur'));
                    }
                  } catch (e) {
                    print(
                        '[HomePage] Erreur lors du traitement des données: $e');
                    return Center(
                        child:
                            Text('Erreur lors du traitement des données: $e'));
                  }

                  if (orders.isEmpty) {
                    return Center(child: Text('Aucune commande récente'));
                  }

                  print('[HomePage] Affichage de ${orders.length} commandes.');

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      // Extraction ultra-sûre des données avec valeurs par défaut
                      final int orderId = _safeGetInt(order, 'id', 0);
                      final double totalAmount =
                          _safeGetDouble(order, 'montant_total', 0.0);
                      final String status =
                          _safeGetString(order, 'status', 'Inconnu');
                      final String dateStr =
                          _safeGetString(order, 'date_commande', '');

                      String formattedDate = 'Date inconnue';
                      if (dateStr.isNotEmpty) {
                        try {
                          DateTime date = DateTime.parse(dateStr).toLocal();
                          formattedDate =
                              "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                        } catch (e) {
                          formattedDate = 'Date invalide';
                        }
                      }

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Icon(Icons.receipt_long,
                              color: Theme.of(context).primaryColor),
                          title: Text('Commande n°$orderId'),
                          subtitle:
                              Text('Statut: $status\nDate: $formattedDate'),
                          trailing: Text('${totalAmount.toStringAsFixed(2)} €'),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailsPage(order: order),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthodes utilitaires pour extraire les données de manière sûre
  int _safeGetInt(Map<String, dynamic> map, String key, int defaultValue) {
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
      Map<String, dynamic> map, String key, double defaultValue) {
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
      Map<String, dynamic> map, String key, String defaultValue) {
    try {
      final value = map[key];
      if (value == null) return defaultValue;
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  // On revient à localhost
  final String _baseUrl = 'http://localhost:3006/api';

  /// Récupère tous les détails d'une commande (articles et historique) en un seul appel.
  Future<Map<String, dynamic>> getFullOrderDetails(int orderId) async {
    // La nouvelle route est /api/commandes/:id/details
    final url = Uri.parse('$_baseUrl/commandes/$orderId/details');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des détails de la commande.');
    }
  }
}

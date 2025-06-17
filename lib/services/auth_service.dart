import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // On revient à localhost
  final String _baseUrl = 'http://localhost:3006/api'; 

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'), // Corrigez l'URL ici
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de connexion : ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    // Vérification simple pour éviter les appels avec des ID invalides (optionnel mais recommandé)
    if (userId.isEmpty || userId == 'null') {
      throw Exception('Tentative de récupération de détails avec un userId invalide: "$userId"');
    }

    final url = Uri.parse('$_baseUrl/users/$userId');
    print('URL utilisée : $url'); // Log URL

    try {
      final response = await http.get(url);

      print('Statut de la réponse : ${response.statusCode}'); // Log Status
      // Décoder la réponse brute pour l'afficher, même si elle est invalide plus tard
      String responseBodyForLogging;
      try {
        // Tenter de formater pour une meilleure lisibilité si c'est du JSON
        var decodedForLog = jsonDecode(response.body);
        responseBodyForLogging = jsonEncode(decodedForLog); // Ré-encoder proprement
      } catch (e) {
        responseBodyForLogging = response.body; // Si pas JSON, afficher tel quel
      }
      print('Réponse brute : $responseBodyForLogging'); // Log Raw Body (potentially formatted)


      if (response.statusCode == 200) {
        // Vérifier explicitement si le corps est la chaîne "null" ou vide
        if (response.body.trim() == 'null' || response.body.trim().isEmpty) {
           throw Exception('Réponse API vide ou littéralement "null" pour userId: $userId');
        }

        final decodedJson = jsonDecode(response.body);
        print('Données décodées (type: ${decodedJson.runtimeType}): $decodedJson'); // Log Decoded Data + Type

        // Gérer le cas où l'API retourne un TABLEAU JSON
        if (decodedJson is List) {
          if (decodedJson.isEmpty) {
            throw Exception('Tableau de données utilisateur vide reçu pour userId: $userId');
          }
          // Assumer que le premier élément est l'utilisateur recherché
          final userData = decodedJson[0];
          if (userData is Map<String, dynamic>) {
            print('Utilisateur trouvé (depuis liste): $userData');
            return userData;
          } else {
            throw Exception('Le premier élément du tableau n\'est pas une Map<String, dynamic>. Reçu: ${userData.runtimeType}');
          }
        }
        // Gérer le cas où l'API retourne un OBJET JSON directement
        else if (decodedJson is Map<String, dynamic>) {
          print('Utilisateur trouvé (depuis objet): $decodedJson');
          return decodedJson;
        }
        // Gérer les autres cas invalides
        else {
          throw Exception('Format de données utilisateur inattendu reçu (type: ${decodedJson.runtimeType})');
        }
      } else {
        // Log de l'erreur API avec le corps de la réponse
        throw Exception(
            'Erreur API (${response.statusCode}) pour $url. Réponse: ${response.body}');
      }
    } catch (e) {
      // Attraper les erreurs réseau ou de décodage JSON
      print('Exception dans getUserDetails pour userId $userId: $e');
      if (e is FormatException) {
        throw Exception('Erreur de format JSON lors de la récupération des détails utilisateur: $e');
      }
      // Relancer l'exception originale ou une nouvelle
      throw Exception('Erreur lors de la récupération des détails utilisateur: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    // Construction de l'URL finale
    final url = Uri.parse('$_baseUrl/commandes/user/$userId/orders');
    print('[AuthService] Appel API Commandes URL: $url'); // Log important

    try {
      final response = await http.get(url);
      print('[AuthService] Réponse API Commandes Statut: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          // Décoder le corps de la réponse en tant que liste
          List<dynamic> decodedData = jsonDecode(response.body);
          // Convertir en liste de Map
          List<Map<String, dynamic>> orders = List<Map<String, dynamic>>.from(decodedData);
          print('[AuthService] ${orders.length} commandes décodées avec succès.');
          return orders;
        } catch (e) {
           print('[AuthService] Erreur de décodage JSON Commandes: $e');
           print('[AuthService] Corps réponse brut Commandes: ${response.body}'); // Afficher le corps brut
           throw Exception('Format de réponse invalide depuis l\'API commandes.');
        }
      } else {
        // Erreur HTTP
        print('[AuthService] Erreur API Commandes (${response.statusCode}): ${response.body}');
        throw Exception('Erreur API (${response.statusCode}) lors de la récupération des commandes.');
      }
    } catch (e) {
      // Erreur réseau ou autre
      print('[AuthService] Exception réseau/autre Commandes: $e');
      throw Exception('Erreur réseau lors de la récupération des commandes: $e');
    }
  }
}

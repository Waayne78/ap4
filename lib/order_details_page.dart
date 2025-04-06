import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order; // Remplacez par votre modèle de commande si vous en avez un

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la commande #${order['id']}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations de la commande',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Divider(),
                    _buildDetailRow('Date', order['date']),
                    _buildDetailRow('Statut', order['status']),
                    _buildDetailRow('Total', '${order['total']}€'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Articles commandés',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Divider(),
                    // Liste des articles
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (order['items'] as List).length,
                      itemBuilder: (context, index) {
                        final item = order['items'][index];
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text('Quantité: ${item['quantity']}'),
                          trailing: Text('${item['price']}€'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckOrdersPage extends StatelessWidget {
  const CheckOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;

              final status = orderData['status'] as String? ?? 'Unknown';
              final items = orderData['items'] as List<dynamic>? ?? [];
              final totalPrice = orderData['totalPrice'] as double? ?? 0.0;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text("Order ID: $orderId"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: $status"),
                      const SizedBox(height: 4),
                      Text("Items:"),
                      ...items.map((item) {
                        return Text(
                          "${item['name']} (Qty: ${item['quantity']}) - ₱${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 12),
                        );
                      }).toList(),
                    ],
                  ),
                  trailing: Text("Total: ₱${totalPrice.toStringAsFixed(2)}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
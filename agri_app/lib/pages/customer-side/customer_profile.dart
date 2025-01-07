import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_app/pages/customer-side/data/firestore_database.dart';

class Order {
  final String id;
  final double total;
  final DateTime date;
  final String status;
  final List<Map<String, dynamic>> items;

  Order({
    required this.id,
    required this.total,
    required this.date,
    required this.status,
    required this.items,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      total: (data['totalPrice'] as num).toDouble(),
      date: (data['orderDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pending',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      setState(() => _isLoading = true);
      final QuerySnapshot orderDocs = await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      setState(() {
        _orders = orderDocs.docs
            .map((doc) => Order.fromFirestore(doc))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading orders")),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildOrderHistorySection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_orders.isEmpty) {
      return const Center(
        child: Text(
          "No orders yet",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Order History",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            final order = _orders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Text("Order #${order.id.substring(0, 8)}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ${_formatDate(order.date)}"),
                    Text("Items: ${order.items.length}"),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₱${order.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order.status,
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                onTap: () => _showOrderDetails(order),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'in transit':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Order Details #${order.id.substring(0, 8)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Date: ${_formatDate(order.date)}"),
            Text("Status: ${order.status}"),
            const SizedBox(height: 10),
            const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return ListTile(
                  title: Text(item['product']['name']),
                  subtitle: Text("Quantity: ${item['quantity']}"),
                  trailing: Text(
                    "₱${(item['product']['price'] * item['quantity']).toStringAsFixed(2)}",
                  ),
                );
              },
            ),
            const Divider(),
            Text(
              "Total: ₱${order.total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Add functionality for editing profile
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "User Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text("Name: Amancio"),
                const Text("Email: amancio@example.com"),
                const SizedBox(height: 20),
                _buildOrderHistorySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
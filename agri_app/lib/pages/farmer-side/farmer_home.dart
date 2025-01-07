// farmer_home_page.dart
import 'package:agri_app/pages/farmer-side/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:agri_app/pages/farmer-side/add_product.dart';
import 'package:agri_app/pages/farmer-side/view_listing.dart';
import 'package:agri_app/pages/farmer-side/check_order.dart';
import 'package:agri_app/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  // Logout function with error handling
  Future<void> _logout(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      // Add any cleanup or logout logic here
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showErrorSnackBar("Failed to logout: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Error handling helper
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Navigation functions
  void _viewListings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ViewListingsPage()),
    );
  }

  void _addProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
  }

  void _checkOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckOrdersPage()),
    );
  }

  // Delete product function
  Future<void> _deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product deleted successfully")),
      );
    } catch (e) {
      _showErrorSnackBar("Failed to delete product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green.shade700),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Farmer Panel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Profile"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text("Add Product"),
              onTap: _addProduct,
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("View Listings"),
              onTap: _viewListings,
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Check Orders"),
              onTap: _checkOrders,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text("Logout"),
                onTap: () => _logout(context),
              ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Farmer Dashboard"),
        backgroundColor: Colors.green.shade700,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Card(
                color: Colors.green.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, Farmer!",
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Here's a quick overview of your farm's performance today."),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Quick Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(
                    "Add Product",
                    Icons.add_circle,
                    Colors.green,
                    _addProduct,
                  ),
                  _buildQuickAction(
                    "View Listings",
                    Icons.list_alt,
                    Colors.orange,
                    _viewListings,
                  ),
                  _buildQuickAction(
                    "Check Orders",
                    Icons.shopping_cart,
                    Colors.blue,
                    _checkOrders,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Products Section
              Text(
                "Your Products",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('products')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inventory_2_outlined, size: 48),
                            const SizedBox(height: 16),
                            const Text(
                              "No products found",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _addProduct,
                              child: const Text("Add Your First Product"),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final data = doc.data() as Map<String, dynamic>;

                        return Dismissible(
                          key: Key(doc.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Product"),
                                content: const Text(
                                  "Are you sure you want to delete this product?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) => _deleteProduct(doc.id),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.local_florist,
                                  color: Colors.green,
                                ),
                              ),
                              title: Text(
                                data['name'] as String? ?? 'Unnamed Product',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    data['description'] as String? ??
                                        'No description',
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                       Text(
                                       "Price: ₱${((data['price'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        "Stock: ${(data['stock'] as num?)?.toInt() ?? 0} ${data['unit'] as String? ?? 'units'}",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      data['category'] as String? ??
                                          'Uncategorized',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
  icon: const Icon(Icons.more_vert, color: Colors.green),
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 'edit',
      child: Row(
        children: const [
          Icon(Icons.edit, color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Text('Edit'),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'delete',
      child: Row(
        children: const [
          Icon(Icons.delete, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Text('Delete'),
        ],
      ),
    ),
  ],
  onSelected: (value) async {
    if (value == 'edit') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductPage(
            productId: doc.id,
            productData: data,
          ),
        ),
      );
    } else if (value == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Product"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          await FirebaseFirestore.instance
              .collection('products')
              .doc(doc.id)
              .delete();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Product deleted successfully"),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error deleting product: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  },
),
                            ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickAction(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// admin_home.dart
import 'package:agri_app/pages/admin-side/admin_feedback.dart';
import 'package:agri_app/pages/admin-side/admin_view_listings.dart';
import 'package:agri_app/pages/admin-side/user_registrations.dart';
import 'package:agri_app/pages/admin-side/view_farm_screen.dart';
import 'package:flutter/material.dart';
import 'package:agri_app/pages/login_page.dart';
import 'package:agri_app/pages/admin-side/admin_profile.dart';
import 'package:agri_app/pages/admin-side/add_farm_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToViewFarms(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ViewFarmsScreen()),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminProfile()),
    );
  }

  void _navigateToAdminViewListings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminViewListingsPage()),
    );
  }

  void _navigateToAddFarm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFarmScreen()),
    );
  }

  void _navigateToUserRegistrations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserRegistrationsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AgriConnect Admin Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle platform notifications
            },
          ),
        ],
      ),
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
                    "AgriConnect Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Platform Management",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminHome()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                _navigateToProfile(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.agriculture),
              title: const Text("Farm Management"),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddFarm(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Feedback"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminFeedback()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("User  Registrations"),
              onTap: () {
                Navigator.pop(context);
                _navigateToUserRegistrations(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Product Listings"),
              onTap: () {
                Navigator.pop(context);
                _navigateToAdminViewListings(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOverviewCard(
                    title: "Total Farmers",
                    value: "150",
                    color: Colors.green,
                  ),
                  _buildOverviewCard(
                    title: "Total Buyers",
                    value: "200",
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOverviewCard(
                    title: "Product Listings",
                    value: "750",
                    color: Colors.orange,
                  ),
                  _buildOverviewCard(
                    title: "Total Farms",
                    value: "45",
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Recent Transactions",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildRecentTransactionsList(),
              const SizedBox(height: 24),
              Text(
                "Platform Management",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPlatformManagementLinks(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddFarm(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 160,
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No recent transactions found."));
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderData = orders[index].data() as Map<String, dynamic>;
            final orderId = orders[index].id;
            final status = orderData['status'] as String? ?? 'Unknown';
            final totalPrice = orderData['totalPrice'] as double? ?? 0.0;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text("Order ID: $orderId"),
                subtitle: Text("Status: $status"),
                trailing: Text("Total: ₱${totalPrice.toStringAsFixed(2)}"),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlatformManagementLinks(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.people, color: Colors.blue),
          title: const Text("User  Registrations"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserRegistrationsPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.agriculture, color: Colors.green),
          title: const Text("Farm Management"),
          onTap: () => _navigateToAddFarm(context),
        ),
        ListTile(
          leading: const Icon(Icons.list_alt, color: Colors.green),
          title: const Text("Product Listings"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminViewListingsPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback, color: Colors.orange),
          title: const Text("Feedback"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminFeedback()),
            );
          },
        ),
      ],
    );
  }
}

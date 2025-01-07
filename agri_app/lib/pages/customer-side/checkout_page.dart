import 'package:agri_app/pages/customer-side/data/firestore_database.dart';
import 'package:flutter/material.dart';
 // Import FirestoreDatabase

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

   CheckoutPage({super.key, required this.cartItems});

  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();

  void _confirmOrder(BuildContext context) {
    double totalPrice = cartItems.fold(
      0,
      (sum, item) => sum + (item['product'].price * item['quantity']),
    );

    // Add the order to Firestore
    _firestoreDatabase.addOrder(cartItems, totalPrice).then((_) {
      // After successful order placement, show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order confirmed and placed!")),
      );

      // Clear the cart (optional)
      cartItems.clear();

      // Redirect to a different screen or back to the home page
      Navigator.pop(context);  // Go back to the previous screen (cart or home)
    }).catchError((e) {
      // Handle error if order placement fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error placing order. Please try again.")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(
      0,
      (sum, item) => sum + (item['product'].price * item['quantity']),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index]['product'];
                final quantity = cartItems[index]['quantity'];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    "₱${product.price.toStringAsFixed(2)} x $quantity = ₱${(product.price * quantity).toStringAsFixed(2)}",
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Total: ₱${totalPrice.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _confirmOrder(context);  // Call the confirm order method
              },
              child: const Text("Confirm Order"),
            ),
          ],
        ),
      ),
    );
  }
}

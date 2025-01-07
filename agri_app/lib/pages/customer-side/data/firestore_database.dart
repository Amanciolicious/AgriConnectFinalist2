import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_app/pages/customer-side/models/product.dart';

class FirestoreDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add product to Firestore
  Future<void> addProduct(Product product) async {
    try {
      // Reference to the 'products' collection
      CollectionReference products = _firestore.collection('products');
      
      // Add product data
      await products.add({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'unit': product.unit,
        'image': product.image,
        'category': product.category,
        'stock': product.stock,
        'rating': product.rating,
        'customerId': product.customerId,
        'deliveryAddress': product.deliveryAddress,
        'barangay': product.barangay,
        'city': product.city,
        'postalCode': product.postalCode,
        'province': product.province,
        'street': product.street,
        'deliveryFee': product.deliveryFee,
        'deliveryMethod': product.deliveryMethod,
        'farmerId': product.farmerId,
        'createdAt': product.createdAt,
        'items': product.items,
        'paymentMethod': product.paymentMethod,
        'paymentStatus': product.paymentStatus,
        'status': product.status,
        'totalAmount': product.totalAmount,
      });
      
      print("Product added successfully");
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  // Get all products from Firestore
  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('products').get();
      
      // Convert the query snapshot to a list of Product objects
      List<Product> products = querySnapshot.docs.map((doc) {
        return Product(
          id: doc.id,
          name: doc['name'],
          description: doc['description'],
          price: doc['price'].toDouble(),
          unit: doc['unit'],
          image: doc['image'],
          category: doc['category'],
          stock: doc['stock'],
          rating: doc['rating']?.toDouble() ?? 0.0, // Safely handle missing rating
          customerId: doc['customerId'] ?? '',
          
          barangay: doc['barangay'] ?? '',
          city: doc['city'] ?? '',
          postalCode: doc['postalCode'] ?? '',
          province: doc['province'] ?? '',
          street: doc['street'] ?? '',
          deliveryFee: doc['deliveryFee']?.toDouble() ?? 0.0,
          deliveryMethod: doc['deliveryMethod'] ?? '',
          farmerId: doc['farmerId'] ?? '',
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          items: List<Map<String, dynamic>>.from(doc['items'] ?? []),
          paymentMethod: doc['paymentMethod'] ?? '',
          paymentStatus: doc['paymentStatus'] ?? '',
          status: doc['status'] ?? '',
          totalAmount: doc['totalAmount']?.toDouble() ?? 0.0, deliveryAddress: {},
        );
      }).toList();
      
      return products;
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  // Update a product in Firestore
  Future<void> updateProduct(Product product) async {
    try {
      // Reference to the product document
      DocumentReference productRef = _firestore.collection('products').doc(product.id);
      
      // Update product data
      await productRef.update({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'unit': product.unit,
        'image': product.image,
        'category': product.category,
        'stock': product.stock,
        'rating': product.rating,
        'customerId': product.customerId,
        'deliveryAddress': product.deliveryAddress,
        'barangay': product.barangay,
        'city': product.city,
        'postalCode': product.postalCode,
        'province': product.province,
        'street': product.street,
        'deliveryFee': product.deliveryFee,
        'deliveryMethod': product.deliveryMethod,
        'farmerId': product.farmerId,
        'createdAt': product.createdAt,
        'items': product.items,
        'paymentMethod': product.paymentMethod,
        'paymentStatus': product.paymentStatus,
        'status': product.status,
        'totalAmount': product.totalAmount,
      });
      
      print("Product updated successfully");
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  // Delete a product from Firestore
  Future<void> deleteProduct(String productId) async {
    try {
      // Reference to the product document
      DocumentReference productRef = _firestore.collection('products').doc(productId);
      
      // Delete the product
      await productRef.delete();
      
      print("Product deleted successfully");
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  // Add order to Firestore
  Future<void> addOrder(List<Map<String, dynamic>> cartItems, double totalPrice) async {
  try {
    CollectionReference orders = _firestore.collection('orders');

    List<Map<String, dynamic>> orderItems = cartItems.map((item) {
      return {
        'productId': item['product'].id,
        'name': item['product'].name,
        'quantity': item['quantity'],
        'price': item['product'].price,
      };
    }).toList();

    await orders.add({
      'items': orderItems,
      'totalPrice': totalPrice,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update product stock after order is placed
    for (var item in cartItems) {
      Product product = item['product'];
      num updatedStock = product.stock.toInt() - item['quantity'];
      await updateProductStock(product.id, updatedStock);
    }

    print("Order placed successfully");
  } catch (e) {
    print("Error placing order: $e");
  }
}
  // Update product stock in Firestore
  Future<void> updateProductStock(String productId, num updatedStock) async {
    try {
      // Reference to the product document
      DocumentReference productRef = _firestore.collection('products').doc(productId);
      
      // Update the stock of the product
      await productRef.update({
        'stock': updatedStock,
      });
      
      print("Product stock updated successfully");
    } catch (e) {
      print("Error updating product stock: $e");
    }
  }
}

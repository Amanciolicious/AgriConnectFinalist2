import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String description;
  double price;
  String unit;
  String image;
  String category;
  int stock;
  double rating;
  
  // New fields based on your request
  String customerId;
  Map<String, String> deliveryAddress;
  String barangay;
  String city;
  String postalCode;
  String province;
  String street;
  double deliveryFee;
  String deliveryMethod;
  String farmerId;
  DateTime createdAt;
  List<Map<String, dynamic>> items;
  String paymentMethod;
  String paymentStatus;
  String status;
  double totalAmount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.image,
    required this.category,
    required this.stock,
    required this.rating,
    required this.customerId,
    required this.deliveryAddress,
    required this.barangay,
    required this.city,
    required this.postalCode,
    required this.province,
    required this.street,
    required this.deliveryFee,
    required this.deliveryMethod,
    required this.farmerId,
    required this.createdAt,
    required this.items,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.totalAmount,
  });

  // Convert a Firestore document to a Product object
  factory Product.fromFirestore(Map<String, dynamic> firestoreData, String id) {
    return Product(
      id: id,
      name: firestoreData['name'] ?? '',
      description: firestoreData['description'] ?? '',
      price: firestoreData['price']?.toDouble() ?? 0.0,
      unit: firestoreData['unit'] ?? '',
      image: firestoreData['image'] ?? '',
      category: firestoreData['category'] ?? '',
      stock: firestoreData['stock'] ?? 0,
      rating: firestoreData['rating']?.toDouble() ?? 0.0,
      customerId: firestoreData['customerId'] ?? '',
      deliveryAddress: firestoreData['deliveryAddress'] ?? {},
      barangay: firestoreData['barangay'] ?? '',
      city: firestoreData['city'] ?? '',
      postalCode: firestoreData['postalCode'] ?? '',
      province: firestoreData['province'] ?? '',
      street: firestoreData['street'] ?? '',
      deliveryFee: firestoreData['deliveryFee']?.toDouble() ?? 0.0,
      deliveryMethod: firestoreData['deliveryMethod'] ?? '',
      farmerId: firestoreData['farmerId'] ?? '',
      createdAt: (firestoreData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: List<Map<String, dynamic>>.from(firestoreData['items'] ?? []),
      paymentMethod: firestoreData['paymentMethod'] ?? '',
      paymentStatus: firestoreData['paymentStatus'] ?? '',
      status: firestoreData['status'] ?? '',
      totalAmount: firestoreData['totalAmount']?.toDouble() ?? 0.0,
    );
  }

  // Convert a Product object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'image': image,
      'category': category,
      'stock': stock,
      'rating': rating,
      'customerId': customerId,
      'deliveryAddress': deliveryAddress,
      'barangay': barangay,
      'city': city,
      'postalCode': postalCode,
      'province': province,
      'street': street,
      'deliveryFee': deliveryFee,
      'deliveryMethod': deliveryMethod,
      'farmerId': farmerId,
      'createdAt': createdAt,
      'items': items,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status,
      'totalAmount': totalAmount,
    };
  }
}

import 'package:agri_app/pages/customer-side/models/product.dart';
import 'package:flutter/material.dart';
import 'firestore_database.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _ratingController = TextEditingController();  // Added rating controller

  // New fields
  final _customerIdController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _barangayController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _provinceController = TextEditingController();
  final _streetController = TextEditingController();
  final _deliveryFeeController = TextEditingController();
  final _deliveryMethodController = TextEditingController();
  final _farmerIdController = TextEditingController();
  final _itemsController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _paymentStatusController = TextEditingController();
  final _statusController = TextEditingController();
  final _totalAmountController = TextEditingController();

  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();

  void _addProduct() {
    final newProduct = Product(
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      unit: _unitController.text,
      image: _imageController.text,
      category: _categoryController.text,
      stock: int.parse(_stockController.text),
      rating: double.parse(_ratingController.text),  // Pass rating value
      customerId: _customerIdController.text,
      deliveryAddress: {
        'barangay': _barangayController.text,
        'city': _cityController.text,
        'postalCode': _postalCodeController.text,
        'province': _provinceController.text,
        'street': _streetController.text,
      },
      deliveryFee: double.parse(_deliveryFeeController.text),
      deliveryMethod: _deliveryMethodController.text,
      farmerId: _farmerIdController.text,
      createdAt: DateTime.now(),
      items: [], // This can be updated later when order items are added
      paymentMethod: _paymentMethodController.text,
      paymentStatus: _paymentStatusController.text,
      status: _statusController.text,
      totalAmount: double.parse(_totalAmountController.text), id: '', barangay: '', city: '', postalCode: '', province: '', street: '',
    );

    _firestoreDatabase.addProduct(newProduct);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Product Name')),
              TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price')),
              TextField(controller: _unitController, decoration: const InputDecoration(labelText: 'Unit')),
              TextField(controller: _imageController, decoration: const InputDecoration(labelText: 'Image URL')),
              TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: _stockController, decoration: const InputDecoration(labelText: 'Stock')),
              TextField(
                controller: _ratingController, 
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(controller: _customerIdController, decoration: const InputDecoration(labelText: 'Customer ID')),
              TextField(controller: _barangayController, decoration: const InputDecoration(labelText: 'Barangay')),
              TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
              TextField(controller: _postalCodeController, decoration: const InputDecoration(labelText: 'Postal Code')),
              TextField(controller: _provinceController, decoration: const InputDecoration(labelText: 'Province')),
              TextField(controller: _streetController, decoration: const InputDecoration(labelText: 'Street')),
              TextField(controller: _deliveryFeeController, decoration: const InputDecoration(labelText: 'Delivery Fee')),
              TextField(controller: _deliveryMethodController, decoration: const InputDecoration(labelText: 'Delivery Method')),
              TextField(controller: _farmerIdController, decoration: const InputDecoration(labelText: 'Farmer ID')),
              TextField(controller: _paymentMethodController, decoration: const InputDecoration(labelText: 'Payment Method')),
              TextField(controller: _paymentStatusController, decoration: const InputDecoration(labelText: 'Payment Status')),
              TextField(controller: _statusController, decoration: const InputDecoration(labelText: 'Status')),
              TextField(controller: _totalAmountController, decoration: const InputDecoration(labelText: 'Total Amount')),
              ElevatedButton(
                onPressed: _addProduct,
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

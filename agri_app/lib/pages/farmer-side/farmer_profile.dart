import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerProfile extends StatefulWidget {
  const FarmerProfile({super.key});

  @override
  State<FarmerProfile> createState() => _FarmerProfileState();
}

class _FarmerProfileState extends State<FarmerProfile> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _barangayController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  bool _isEditing = false; // To toggle between edit and view mode
  String? _farmerId; // To store the document ID of the farmer profile

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // Load existing profile data from Firestore
    // Replace 'your_farmer_id' with the actual ID of the farmer document
    // You might want to pass this ID to the FarmerProfile widget
    final doc = await FirebaseFirestore.instance
        .collection('farmers')
        .doc('your_farmer_id')
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _farmerId = doc.id; // Store the document ID
      _nameController.text = data['name'];
      _emailController.text = data['email'];
      _phoneController.text = data['phone'];
      _streetController.text = data['address']['street'];
      _barangayController.text = data['address']['barangay'];
      _cityController.text = data['address']['city'];
      _provinceController.text = data['address']['province'];
      _postalCodeController.text = data['address']['postalCode'];
      // Load the profile image if available
      if (data['profileImage'] != null) {
        _profileImage = File(data['profileImage']);
      }
      setState(() {});
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

  Future<void> _saveProfile() async {
    // Save or update the profile data to Firestore
    final farmerData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': {
        'street': _streetController.text,
        'barangay': _barangayController.text,
        'city': _cityController.text,
        'province': _provinceController.text,
        'postalCode': _postalCodeController.text,
      },
      'profileImage': _profileImage?.path, // Save the image path or URL
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      if (_farmerId != null) {
        // Update existing profile
        await FirebaseFirestore.instance
            .collection('farmers')
            .doc(_farmerId)
            .update(farmerData);
      } else {
        // Create new profile
        await FirebaseFirestore.instance.collection('farmers').add(farmerData);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully")),
      );
      setState(() {
        _isEditing = false; // Exit edit mode after saving
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Profile '),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing; // Toggle edit mode
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  if (_isEditing) // Show edit icon only in edit mode
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
            // Input Fields
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
              enabled: _isEditing, // Enable editing based on mode
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              enabled: _isEditing,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              enabled: _isEditing,
            ),
            TextField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: "Street"),
              enabled: _isEditing,
            ),
            TextField(
              controller: _barangayController,
              decoration: const InputDecoration(labelText: "Barangay"),
              enabled: _isEditing,
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: "City"),
              enabled: _isEditing,
            ),
            TextField(
              controller: _provinceController,
              decoration: const InputDecoration(labelText: "Province"),
              enabled: _isEditing,
            ),
            TextField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: "Postal Code"),
              enabled: _isEditing,
            ),
            const SizedBox(height: 20),
            if (_isEditing) // Show save button only in edit mode
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Profile"),
              ),
          ],
        ),
      ),
    );
  }
}

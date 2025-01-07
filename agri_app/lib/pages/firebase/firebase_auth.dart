import 'package:agri_app/pages/admin-side/admin_home.dart';
import 'package:agri_app/pages/customer-side/customer_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Save user info with default role to Firestore
      await _firestore.collection("users").doc(credential.user!.uid).set({
        "username": username,
        "email": email,
        "password": password,
        "role": "customer", // Assign default role
      });

      return credential.user;
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<void> loginAndRedirect(
      BuildContext context, String email, String password) async {
    try {
      User? user = await signInWithEmailAndPassword(email, password);
      if (user != null) {
        // Fetch user role from Firestore
        DocumentSnapshot snapshot =
            await _firestore.collection("users").doc(user.uid).get();
        String role = snapshot.get("role");

        // Redirect based on role
        if (role == "customer") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CustomerHome()),
          );
        } else if (role == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHome()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unknown role. Please contact support.")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Please try again.")),
      );
      print("Login Error: $e");
    }
  }
}

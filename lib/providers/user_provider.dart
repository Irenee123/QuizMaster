import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _fullName;
  String? _email;
  String? _location;
  String? _phone;

  String? get fullName => _fullName;
  String? get email => _email;
  String? get location => _location;
  String? get phone => _phone;

  Future<void> saveUserData({
    required String fullName,
    required String email,
    required String location,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    await prefs.setString('email', email);
    await prefs.setString('location', location);
    await prefs.setString('phone', phone);

    _fullName = fullName;
    _email = email;
    _location = location;
    _phone = phone;

    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _fullName = prefs.getString('fullName') ?? '';
    _email = prefs.getString('email') ?? '';
    _location = prefs.getString('location') ?? '';
    _phone = prefs.getString('phone') ?? '';
    notifyListeners();
  }

  // Method to clear data on logout
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fullName');
    await prefs.remove('email');
    await prefs.remove('location');
    await prefs.remove('phone');

    _fullName = null;
    _email = null;
    _location = null;
    _phone = null;

    notifyListeners();
  }

  // Sign Up with Email
  Future<String?> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    required String location,
    required String phone,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Store user details in Firestore
      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'location': location,
        'phone': phone,
        'createdAt': Timestamp.now(),
      });

      // Update provider with actual user details
      await saveUserData(fullName: fullName, email: email, location: location, phone: phone);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Sign In with Email
  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user details from Firestore
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        _fullName = data['fullName'] ?? '';
        _email = data['email'] ?? '';
        _phone = data['phone'] ?? '';
        _location = data['location'] ?? '';

        // Store the retrieved user data
        await saveUserData(fullName: _fullName!, email: _email!, location: _location!, phone: _phone!);
        notifyListeners();
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
    await clearUserData();
  }
}
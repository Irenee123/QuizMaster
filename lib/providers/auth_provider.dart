import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Profile data
  String fullName = '';
  String email = '';
  String phone = '';
  String location = '';

  User? get currentUser => _auth.currentUser;

  void setLoading(bool value) {
    _isLoading = value;
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

      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'location': location,
        'createdAt': Timestamp.now(),
      });

      // Load user data after sign-up
      await loadUserData();

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

      // Fetch and load user details
      await loadUserData();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Google Sign-In
  Future<String?> signInWithGoogle() async {
    try {
      setLoading(true);
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        setLoading(false);
        return "Google sign-in cancelled.";
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();

        if (!userDoc.exists) {
          await _firestore.collection("users").doc(user.uid).set({
            'fullName': user.displayName ?? '',
            'email': user.email ?? '',
            'phone': '',
            'location': '',
            'createdAt': Timestamp.now(),
          });
        }

        // Load user data after Google sign-in
        await loadUserData();
      }

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      setLoading(false);
    }
  }

  // Load user data from Firestore
  Future<void> loadUserData() async {
    if (_auth.currentUser != null) {
      try {
        var snapshot = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;

          fullName = data['fullName'] ?? '';
          email = data['email'] ?? '';
          phone = data['phone'] ?? '';
          location = data['location'] ?? '';

          notifyListeners();
        }
      } catch (e) {
        print("Error loading user data: $e");
      }
    }
  }

  // Save user data to Firestore
  Future<void> saveUserData() async {
    if (_auth.currentUser != null) {
      try {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'location': location,
        });

        notifyListeners();
      } catch (e) {
        print("Error saving user data: $e");
      }
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();

    // Clear stored user data
    fullName = '';
    email = '';
    phone = '';
    location = '';

    notifyListeners();
  }
}

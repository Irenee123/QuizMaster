import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

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
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the UID of the created user
      String uid = userCredential.user!.uid;

      // Store user details in Firestore
      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'location': location,
        'createdAt': Timestamp.now(),
      });

      return null; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // Sign In with Email
  Future<String?> signInWithEmail({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user details from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        fullName = data['fullName'] ?? '';
        this.email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        location = data['location'] ?? '';
        notifyListeners();

        // Load the user data and update the profile fields
      await loadUserData();  // This will update the controllers and notify listeners
      }

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
          // Store new Google user in Firestore
          await _firestore.collection("users").doc(user.uid).set({
            'fullName': user.displayName ?? '',
            'email': user.email ?? '',
            'phone': '',
            'location': '',
            'createdAt': Timestamp.now(),
          });
        }

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
    var snapshot = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      fullName = data['fullName'] ?? '';
      email = data['email'] ?? '';
      phone = data['phone'] ?? '';
      location = data['location'] ?? '';
      
      // Update the controllers with the user data
      nameController.text = fullName;
      emailController.text = email;
      phoneController.text = phone;
      locationController.text = location;

      notifyListeners(); // Notify listeners to rebuild the UI
    }
  }
}


  // Save user data to Firestore
  Future<void> saveUserData() async {
    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'location': location,
      });
      notifyListeners();
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
    fullName = '';
    email = '';
    phone = '';
    location = '';
    notifyListeners();
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }
}

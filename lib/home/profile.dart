import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quizmaster/providers/auth_provider.dart';
import 'package:quizmaster/providers/user_provider.dart'; // Import UserProvider

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, UserProvider>( // Use Consumer2 to access both AuthProvider and UserProvider
      builder: (context, authProvider, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: Colors.deepPurple,
            actions: [
              IconButton(
                icon: Icon(authProvider.isLoading ? Icons.save : Iconsax.edit),
                onPressed: () {
                  if (authProvider.isLoading) {
                    authProvider.saveUserData();
                  } else {
                    authProvider.setLoading(true);
                  }
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Icon(Iconsax.user, size: 50, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  userProvider.fullName ?? 'User Name', // Display the user's name from UserProvider
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  userProvider.email ?? 'user@example.com', // Display the user's email from UserProvider
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                _buildTextField(authProvider.phoneController, 'Phone',
                    Iconsax.call, TextInputType.phone),
                _buildTextField(authProvider.locationController, 'Location',
                    Iconsax.location, TextInputType.text),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    await authProvider.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Sign Out'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, dynamic authProvider) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      readOnly: !authProvider.isLoading, // Make the text field editable when loading is true
    );
  }
}
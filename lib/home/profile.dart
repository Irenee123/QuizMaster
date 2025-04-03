import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quizmaster/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Load user data when ProfileScreen is built
        authProvider.loadUserData();

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
                  authProvider.fullName.isNotEmpty ? authProvider.fullName : 'User Name', // Display actual name
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  authProvider.email.isNotEmpty ? authProvider.email : 'user@example.com', // Display actual email
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  TextEditingController(text: authProvider.phone),
                  'Phone',
                  Iconsax.call,
                  authProvider.isLoading,
                ),
                _buildTextField(
                  TextEditingController(text: authProvider.location),
                  'Location',
                  Iconsax.location,
                  authProvider.isLoading,
                ),
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon, bool isEditable) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      readOnly: !isEditable, // Make text field editable only when in edit mode
    );
  }
}
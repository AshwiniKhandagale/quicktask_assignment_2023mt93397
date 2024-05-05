import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93397/auth_service.dart'; // Import your AuthService class
import 'package:quicktask_assignment_2023mt93397/task_management_screen.dart'; // Import your TaskManagementScreen widget

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    
    // Call login function from AuthService
    final loginResult = await AuthService().login(username, password);
    
    // Extract success flag from loginResult
    final success = loginResult['success'] ?? false; // Default to false if 'success' key is not present

    if (success) {
      // If login is successful, navigate to the task management screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskManagementScreen()),
      );
    } else {
      // Handle login failure
      // Display error message or show alert
    }
  }
}

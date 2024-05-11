import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93397/auth_service.dart';
import 'package:quicktask_assignment_2023mt93397/task_management_screen.dart';
import 'package:quicktask_assignment_2023mt93397/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key for form validation
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Assign the form key
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _login();
                      }
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(fontWeight: FontWeight.bold), // Make text bold
                    ),
                  ),
                  SizedBox(height: 8.0), // Add space between Log In and Sign Up buttons
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()), // Navigate to the signup screen
                      );
                    },
                    child: Text('Sign Up'),
                  ),
                  SizedBox(height: 8.0), // Add space for error message
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final loginResult = await AuthService().login(username, password);

      final sessionToken = loginResult['sessionToken'] ?? "";

      if (sessionToken.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskManagementScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } catch (e) {
      print('Error during login: $e');
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }
}

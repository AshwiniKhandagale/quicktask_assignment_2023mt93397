import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93397/auth_service.dart'; // Import your AuthService class
import 'login_screen.dart'; // Import the login screen

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key for form validation
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _signUp();
                  }
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
    );
  }

  Future<void> _signUp() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    try {
      // Call signUp function from AuthService
      await AuthService().signUp(username, password, email, firstName, lastName);

      // Navigate back to the login screen after successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign up failed. Please try again.';
      });
    }
  }
}

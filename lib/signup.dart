// ignore_for_file: use_build_context_synchronously, prefer_const_declarations, avoid_print, sort_child_properties_last, prefer_const_constructors, depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// Import your LoginPage class
import 'login.dart'; // Update with the correct path

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for handling text input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171738),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _buildHeaderText('Sign Up'),
                const SizedBox(height: 24),
                _buildInputField('Username', _usernameController),
                const SizedBox(height: 24),
                _buildPasswordInput(),
                const SizedBox(height: 24),
                _buildCheckboxText('I agree to the Terms of Service'),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
                _buildSignupButton(context),
                const SizedBox(height: 24),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widgets for UI components

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: GoogleFonts.sora(
        textStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9067C6),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return _buildContainer(
      child: TextFormField(
        controller: controller,
        style: _inputTextStyle(),
        decoration: _inputDecoration(label, backgroundColor: Color(0xFFF7ECE1)),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return _buildContainer(
      child: TextFormField(
        obscureText: _obscurePassword,
        controller: _passwordController,
        style: _inputTextStyle(),
        decoration: _inputDecoration('Password',
            backgroundColor: Color(0xFFF7ECE1),
            suffixIcon: _buildPasswordSuffixIcon()),
      ),
    );
  }

  Widget _buildCheckboxText(String text) {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Color(0xFFF7ECE1);
              }
              return Color(0xFFF7ECE1);
            },
          ),
          checkColor: Color(0xFF35368E),
          activeColor: Color(0xFFF7ECE1),
        ),
        Text(
          text,
          style: GoogleFonts.sora(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_agreeToTerms) {
            _performSignup();
          } else {
            _showTermsAlert(context);
          }
        },
        child: Text(
          'Sign Up',
          style: _buttonTextStyle(),
        ),
        style: _buttonStyle(),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context); // Navigate back to the login page
        },
        child: RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: GoogleFonts.sora(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            children: [
              TextSpan(
                text: 'Log in',
                style: GoogleFonts.sora(
                  textStyle: TextStyle(
                    color: Color(0xFF8D86C9), // Color for "Log in"
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7ECE1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: child,
    );
  }

  Widget _buildPasswordSuffixIcon() {
    return IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility : Icons.visibility_off,
        color: Color(0xFF9067C6),
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    );
  }

  // Styles and text configurations

  TextStyle _inputTextStyle() {
    return GoogleFonts.sora(
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText,
      {Widget? suffixIcon, Color? backgroundColor}) {
    final borderColor = backgroundColor ?? Color(0xFFF7ECE1);

    return InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.sora(
        textStyle: TextStyle(
          color: Color(0xFF8D86C9),
          fontSize: 18,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      suffixIcon: suffixIcon,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: backgroundColor,
      filled: true,
    );
  }

  TextStyle _buttonTextStyle() {
    return GoogleFonts.sora(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF9067C6),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      minimumSize: Size(double.infinity, 48),
    );
  }

  // Function to handle signup logic

  void _performSignup() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Check if username or password is empty
    if (username.isEmpty || password.isEmpty) {
      print('Username or password is empty');
      return;
    }

    // Replace 'http://your-server-url:3000/signup' with the actual URL of your Node.js server
    final String serverUrl =
        'http://10.0.2.2:3000/signup'; // Update with your server URL

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Server Response Code: ${response.statusCode}');
      print('Server Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Signup successful
        // Navigate to the login page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), // Replace with your actual login page class
        );
      } else if (response.statusCode == 400) {
        // Signup failed due to existing username
        // Display an error message to the user
        print('Signup failed: Username already exists');
        _showErrorMessage(
            'Username already exists. Please enter another username.');
      } else {
        // Signup failed for other reasons
        // Display a generic error message
        print('Signup failed');
        _showErrorMessage('Signup failed. Please try again later.');
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');
      _showErrorMessage(
          'An error occurred. Please check your network connection and try again.');
    }
  }

  // Function to show an error message
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Color(0xFFF7ECE1),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to show an alert for accepting terms
  void _showTermsAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accept Terms'),
          content: Text('Please accept the Terms of Service to sign up.'),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Color(0xFFF7ECE1),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

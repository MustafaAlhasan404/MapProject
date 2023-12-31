// ignore_for_file: use_build_context_synchronously, prefer_const_declarations, avoid_print, sort_child_properties_last, prefer_const_constructors, depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

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
                _buildInputField('First Name', _firstNameController),
                const SizedBox(height: 24),
                _buildInputField('Last Name', _lastNameController),
                const SizedBox(height: 24),
                _buildInputField('Address', _addressController),
                const SizedBox(height: 24),
                _buildInputField('Birthday', _birthdayController),
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
          Navigator.pop(context);
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
                    color: Color(0xFF8D86C9),
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

  void _performSignup() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String address = _addressController.text;
    final String birthday = _birthdayController.text;

    if (username.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        address.isEmpty ||
        birthday.isEmpty) {
      print('All fields are required');
      _showErrorMessage(
          'All fields are required. Please fill in all the fields.');
      return;
    }

    final String serverUrl = 'http://10.0.2.2:3000/signup';

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'birthday': birthday,
        }),
      );

      if (response.statusCode == 201) {
        // Signup successful
        // Navigate to the home screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), // Replace with your actual login page class
        );
      } else if (response.statusCode == 400) {
        print('Signup failed: Username already exists');
        _showErrorMessage(
            'Username already exists. Please enter another username.');
      } else {
        print('Signup failed');
        _showErrorMessage('Signup failed. Please try again later.');
      }
    } catch (error) {
      print('Error: $error');
      _showErrorMessage(
          'An error occurred. Please check your network connection and try again.');
    }
  }

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

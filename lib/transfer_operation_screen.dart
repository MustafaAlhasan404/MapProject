import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'home.dart'; // Import the HomeScreen
import 'login.dart';

class TransferOperationScreen extends StatefulWidget {
  @override
  _TransferOperationScreenState createState() =>
      _TransferOperationScreenState();
}

class _TransferOperationScreenState extends State<TransferOperationScreen> {
  int _selectedIndex = 1; // Index for the "Transfer" tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171738),
      body: Center(), // You can add your content here
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 0) {
              // If "Home" is pressed, go back to HomeScreen using builder context
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    username: loggedInUser,
                  ),
                ),
              );
            }
          });
        },
      ),
    );
  }
}

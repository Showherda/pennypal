import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:pennypal/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 90, 15, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: CircleAvatar(
                        // Replace with user profile picture
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Hello, Jerry!',
                      style: TextStyle(fontSize: 18, color: Color(0xFF44D9FF)),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // Navigate to profile.dart
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBlurredBox1(),
                  SizedBox(height: 10),
                  _buildBlurredBox2(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF2E2E2E),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
              bottom: Radius.circular(25.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home, 0, 30),
                _buildNavItem(Icons.monetization_on_sharp, 1, 30),
                _buildNavItem(Icons.chat_outlined, 2, 30),
                _buildNavItem(Icons.account_circle, 3, 30),
              ],

            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, double iconSize) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedIndex == index ? Color(0xFF34DDFC) : Colors.transparent,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              icon,
              color: _selectedIndex == index ? Colors.white : Colors.white,
              size: iconSize, // Set the size of the icon
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == index ? Color(0xFF34DDFC) : Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBlurredBox1() {
  //   return Container(
  //     width: double.infinity,
  //     height: 150,
  //     child: DecoratedBox(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         border: Border.all(color: Colors.white, width: 1.2),
  //         gradient: LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           colors: [
  //             Color(0xFF097D9C), // Start color
  //             Color(0xA5869),     // End color
  //           ],
  //         ),
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
  //           child: Padding(
  //             padding: const EdgeInsets.all(1.0), // Adjust the padding as needed
  //             child: Center(
  //               child: Text(
  //                 'Monthly Budget',
  //                 style: TextStyle(fontSize: 20, color: Colors.white),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //
  //     ),
  //
  //   );
  //
  // }

  Widget _buildBlurredBox1() {
    return Container(
      width: double.infinity,
      height: 150,
      child: Stack(
        children: [
          // Background with blur effect
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1.2),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF097D9C), // Start color
                  Color(0xA5869),     // End color
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Monthly Budget',
                      style: TextStyle(fontSize: 16, color: Colors.white,
                      fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Circular progress indicator
          Positioned(
            right: 16.0,
            bottom: 25.0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 10),
              ),
              child: Center(
                child: Text(
                  '\RM500', // Example amount remaining
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredBox2() {
    return Container(
      width: double.infinity,
      height: 410,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1.2),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF097D9C), // Start color
              Color(0xA5869),     // End color
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Padding(
              padding: const EdgeInsets.all(1.0), // Adjust the padding as needed
              child: Center(
                child: Text(
                  'Blurred Box',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to the respective page based on the index
      switch (index) {
        case 0:
        // Navigate to the home page
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
        // Navigate to the monetization page
        // Add your navigation logic here
          Navigator.pushNamed(context, '/transaction');
          break;
        case 2:
        // Navigate to the chat page
        // Add your navigation logic here
          Navigator.pushNamed(context, '/chat');
          break;
        case 3:
        // Navigate to the profile page
          Navigator.pushNamed(context, '/profile');
          break;
        default:
        // Navigate to the home page by default
          Navigator.pushNamed(context, '/home');
          break;
      }
    });
  }
}

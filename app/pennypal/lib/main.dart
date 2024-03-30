import 'dart:ui';
import 'package:pennypal/transaction.dart'; // Import TransactionPage
import 'package:flutter/material.dart';
import 'package:pennypal/profile.dart';
import 'home.dart'; // Import home page
import 'login.dart';
import 'chat.dart';

void main() {
  runApp(PennyPal());
}

class PennyPal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define the routes for app
      routes: {
        '/': (context) => WelcomePage(), // Welcome page route
        '/home': (context) => HomePage(), // Home page route
        '/profile': (context) => ProfilePage(), // Profile page route
        '/login': (context) => LoginPage(), // Login page route
        '/transaction': (context) => TransactionPage(),
        '/chat': (context) => ChatPage(),
        // Add other routes as needed
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // Replace with image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'PennyPal',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                       'Personal Finance Companion',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              // Sliding button
              Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30.0),
                          ),

                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to home page
                              Navigator.pushNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 110.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Color(0xFF34DDFC), width: 1.5),
                              ),
                              primary: Colors.transparent, // Change button color as needed
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                  )

              )
            ],
          ),
        ],
      ),
    );
  }
}

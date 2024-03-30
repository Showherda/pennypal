import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pennypal/home.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center align vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create\nAccount',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center( // Center align the sign in button
                  child: ElevatedButton(
                    onPressed: () {
                      // Sign in functionality
                      // Navigate to home page
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFF3469), // Change button color to pink
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white), // Change text color to white
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1.5,
                        indent: 40, // Adjust the starting point of the divider line
                        endIndent: 10, // Adjust the ending point of the divider line
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1.5,
                        indent: 10, // Adjust the starting point of the divider line
                        endIndent: 40, // Adjust the ending point of the divider line
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    SignInOption(
                      imagePath: 'assets/images/fb.png', // Replace with your Facebook logo image path
                      onTap: () {
                        // Implement Facebook sign-in functionality
                      },
                    ),
                    SizedBox(width: 20),
                    SignInOption(
                      imagePath: 'assets/images/gmail.png', // Replace with your Google logo image path
                      onTap: () {
                        // Implement Google sign-in functionality
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Positioned(
                  bottom: 0.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to login page
                                Navigator.pop(context);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInOption extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const SignInOption({
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: 50,
        height: 50,
      ),
    );
  }
}

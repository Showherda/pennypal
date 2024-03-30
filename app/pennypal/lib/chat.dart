import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _selectedIndex = 2; // Set index for chat page to be highlighted in bottom navigation bar
  List<dynamic> chatMessages = []; // List to store chat messages

  @override
  void initState() {
    super.initState();
    // Fetch chat messages when the page loads
    fetchChatMessages().then((messages) {
      setState(() {
        chatMessages = messages;
      });
    });
  }

  // Method to fetch chat messages from the API
  Future<List<String>> fetchChatMessages() async {
    final response = await http.get(Uri.parse('http://192.168.56.1:8000/incoming-message'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((message) => message['content'].toString()).toList();
    } else {
      throw Exception('Failed to fetch chat messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'PennyPal',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.2),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF097D9C), Color(0xA5869)],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Chatbot messages (left side)
                    _buildChatMessage(isUserMessage: false, message: 'Hello! How can I assist you?', profileImage: 'assets/images/chatbot_profile.jpg'),
                    _buildChatMessage(isUserMessage: false, message: 'Is there anything you need help with?', profileImage: 'assets/images/chatbot_profile.jpg'),
                    // User messages (right side)
                    _buildChatMessage(isUserMessage: true, message: 'Hi! Can you provide more information about...', profileImage: 'assets/images/profile.png'),
                    _buildChatMessage(isUserMessage: true, message: 'I need help with...', profileImage: 'assets/images/profile.png'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Send message text box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Message PennyPal...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                CircleAvatar(
                  backgroundColor: Color(0xFFFF0A64),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Send message functionality
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
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

  Widget _buildChatMessage({
    required bool isUserMessage,
    required String message,
    required String profileImage,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        children: [
          isUserMessage
              ? SizedBox(width: 10.0)
              : CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(profileImage),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Blur color
                    spreadRadius: 0,
                    blurRadius: 1, // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.0), // Whitish/greyish color
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: isUserMessage ? Colors.white : Colors.white,
                        width: 1.2,
                      ), // Solid border with specified color
                    ),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          isUserMessage
              ? CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(profileImage),
          )
              : SizedBox(width: 10.0),
        ],
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
        // Navigate to the transaction page
          Navigator.pushNamed(context, '/transaction');
          break;
        case 2:
        // Already on the chat page
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

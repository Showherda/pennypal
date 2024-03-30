import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:pennypal/api_service.dart'; // Import ApiService

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _selectedIndex = 2; // Set index for chat page to be highlighted in bottom navigation bar
  final myController = TextEditingController();
  List<Widget> chatMessages = [];
  int user_id = 1;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
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
                  children: chatMessages,
                  // [
                  //   // Chatbot messages (left side)
                  //   _buildChatMessage(isUserMessage: false, message: 'Hello! How can I assist you?', profileImage: 'assets/images/profile.png'),
                  //   _buildChatMessage(isUserMessage: false, message: 'Is there anything you need help with?', profileImage: 'assets/images/profile.png'),
                  //   // User messages (right side)
                  //   _buildChatMessage(isUserMessage: true, message: 'Hi! Can you provide more information about...', profileImage: 'assets/images/user_profile.png'),
                  //   _buildChatMessage(isUserMessage: true, message: 'I need help with...', profileImage: 'assets/images/user_profile.png'),
                  // ],
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
                    controller: myController,
                  ),
                ),
                SizedBox(width: 10.0),
                CircleAvatar(
                  backgroundColor: Color(0xFFFF0A64),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Send message functionality
                      // Add user message to chatMessages list
                      chatMessages.add(
                        _buildChatMessage(
                          isUserMessage: true,
                          message: myController.text,
                          profileImage: 'assets/images/profile.png',
                        ),
                      );
                      Future<Map<String, dynamic>> response = ApiService.sendMessage(user_id, myController.text); // Send message to API
                      setState(() {
                        myController.clear();
                      });
                      response.then((value) {
                        // Add chatbot response to chatMessages list
                        chatMessages.add(
                          _buildChatMessage(
                            isUserMessage: false,
                            message: value['content'],
                            profileImage: 'assets/images/chatbot.png',
                          ),
                        );
                        setState(() {
                          myController.clear();
                        });
                        if (value['graph-needed']==1) {
                          var graph = ApiService.getGraphData(user_id); // Get graph data from API
                          if (graph != null) {
                            // Display graph
                            chatMessages.add(
                              Image.memory(
                                Uint8List.fromList(graph as List<int>),
                                width: 300,
                                height: 300,
                              ),
                            );
                          }
                        }
                      });
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

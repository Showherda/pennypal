import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2), // Add border here
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/pic.png'),
                backgroundColor: Colors.transparent,
                // You can replace 'assets/images/profile.png' with the actual path to the user's profile picture
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Edit Name',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Edit Email',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Current Password',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'New Password',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save profile changes functionality
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color(0xFF34DDFC), width: 1.5),
                ),
                primary: Color(0xFFFF3469),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: TextButton(
                onPressed: () {
                  // Navigate to login page
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Color(0xFF34DDFC), width: 1.5),
                  ),
                  primary: Color(0xFFDC143C), // Change button color to pink
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),

      // bottomNavBar
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
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _onItemTapped(index);
      },
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
          break;
        default:
        // Navigate to the home page by default
          Navigator.pushNamed(context, '/');
          break;
      }
    });
  }
}

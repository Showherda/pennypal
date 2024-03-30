import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int _selectedIndex = 1; // Setting the index for this page to be highlighted in the bottom navigation bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Expenses',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date input
            TextField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'Date',
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            // Amount input
            TextField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'Amount',
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            // Category dropdown
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'Category',
              ),
              items: [
                DropdownMenuItem(child: Text('Category 1'), value: 'Category 1'),
                DropdownMenuItem(child: Text('Category 2'), value: 'Category 2'),
                DropdownMenuItem(child: Text('Category 3'), value: 'Category 3'),
              ],
              onChanged: (value) {
                // Handle dropdown value change
              },
            ),
            SizedBox(height: 10),
            // Remark input
            TextField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'Remark',
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            // Description input
            TextField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'Description',
              ),
              style: TextStyle(color: Colors.white),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            // Save button
            ElevatedButton(
              onPressed: () {
                // Save transaction
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color(0xFF34DDFC), width: 1.5),
                ),
                backgroundColor: Color(0xFFFF3469),
              ),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
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
        // Already on the transaction page
          break;
        case 2:
        // Navigate to the chat page
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

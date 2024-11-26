import 'package:flutter/material.dart';
import '/services/auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;
  String _searchText = '';

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //action logic search
              print('Searching for: $_searchText');
            },
          ),
          _selectedIndex == 3 // click Profile
              ? IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    //go to the setting Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen(logout: _logout)),
                    );
                  },
                )
              : Container(),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: 'Search...',
          //       border: OutlineInputBorder(),
          //       prefixIcon: Icon(Icons.search),
          //     ),
          //     onChanged: (value) {
          //       setState(() {
          //         _searchText = value; // Cập nhật giá trị tìm kiếm
          //       });
          //     },
          //   ),
          // ),
          Expanded(
            child: Center(
              child: _selectedIndex == 0
                  ? Text('Home Screen Content')
                  : Text('Profile Screen Content'), // Không cần tạo màn hình riêng cho Profile
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon (Icons.list),
            label: 'List',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[700],
        onTap: _onItemTapped,
      ),
    );
  }
}

// Màn hình cài đặt
class SettingsScreen extends StatelessWidget {
  final VoidCallback logout;

  SettingsScreen({required this.logout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: logout,
          child: Text('Logout'),
        ),
      ),
    );
  }
}

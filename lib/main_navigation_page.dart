import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  final int initialIndex; 

  MainNavigationPage({this.initialIndex = 0});

  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; 
  }

  final List<Widget> _pages = [
    HomePage(), 
    ProfilePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white, 
            selectedItemColor: Colors.blueAccent, 
            unselectedItemColor: Colors.grey, 
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed, 
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), 
                activeIcon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined), 
                activeIcon: Icon(Icons.person), 
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
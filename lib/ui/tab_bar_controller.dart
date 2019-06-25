import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'employees.dart';
import 'wardrobe.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabBarController extends StatefulWidget {
  TabBarController();

  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  _TabBarControllerState();

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Wardrobe(),
    Employees(),
    Wardrobe(),
  ];

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        backgroundColor: Color.fromRGBO(27, 31, 35, 1),
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.amber,
            ),
            title: Text(
              'Wardrobe',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.red,
            ),
            title: Text(
              user.displayName,
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.attach_money,
              color: Colors.green,
            ),
            title: Text(
              'Reports',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

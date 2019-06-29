import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'employees.dart';
import 'wardrobe.dart';

class TabBarController extends StatefulWidget {
  TabBarController();

  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  _TabBarControllerState();

  int _selectedIndex = 0;

  static const List<Widget> _tabs = <Widget>[
    Wardrobe(),
    Wardrobe(),
    Employees(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of(context);

    return _buildScaffold(context, user);
  }

  Scaffold _buildScaffold(BuildContext context, FirebaseUser user) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 38, 43, 1),
        elevation: 0,
        title: Text(
          "VenueName",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        actions: <Widget>[
          FlatButton(
            splashColor: Colors.red,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.undo,
                  color: Colors.white,
//                  size: 12,
                ),
                Text('Undo')
              ],
            ),
            onPressed: () => {
                  print('object'),
                },
          ),
        ],
      ),
      body: Center(
        child: _tabs.elementAt(_selectedIndex),
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
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

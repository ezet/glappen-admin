import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/venue.dart';
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Center _buildBody() {
    return Center(
      child: _tabs.elementAt(_selectedIndex),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    final FirebaseUser user = Provider.of(context);
    return BottomNavigationBar(
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
    );
  }

  AppBar _buildAppBar() {
    Venue venue = Provider.of(context);
    return AppBar(
      backgroundColor: Color.fromRGBO(34, 38, 43, 1),
      elevation: 0,
      title: Text(
        venue?.name ?? "",
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
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garderobeladmin/data/db.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:get_it/get_it.dart';
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
    final FirebaseUser user = Provider.of(context);
    final DatabaseService dbService = Provider.of<GetIt>(context).get();

    return StreamProvider<Venue>.value(
        // TODO: replace with selected venue
        value: dbService.getVenue('KREps4urlJ9Ymy6g9VdY'),
        child: Scaffold(
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
        ));
  }
}

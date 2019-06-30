import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:garderobeladmin/ui/reservations.dart';
import 'package:garderobeladmin/ui/venue.dart';
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
    Reservations(),
    Employees(),
    VenueSettingsView()
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
            Icons.drag_handle,
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
            'Reservations',
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
            Icons.home,
            color: Colors.amber,
          ),
          title: Text(
            'Venue',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  AppBar _buildAppBar() {
    final Venue venue = Provider.of(context);
    final Section section = Provider.of(context);
    final GladminApi api = Provider.of<GetIt>(context).get();

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
            children: <Widget>[Text('Scan in')],
          ),
          onPressed: () async => {await api.simulateCheckInScan(section)},
        ),
        FlatButton(
          splashColor: Colors.red,
          child: Row(
            children: <Widget>[Text('Scan out')],
          ),
          onPressed: () async => {await api.simulateCheckOutScan(section)},
        ),
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garderobeladmin/data/db.dart';
import 'package:provider/provider.dart';

class Employees extends StatefulWidget {
  const Employees({Key key}) : super(key: key);

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Hi, ${user.displayName}. Sign out?'),
          onPressed: () => {FirebaseAuth.instance.signOut()},
        ),
      ),
    );
  }
}

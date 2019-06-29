import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'data/db.dart';
import 'ui/sign_in.dart';
import 'ui/tab_bar_controller.dart';
import 'ui/theme/dark_theme.dart';
import 'ui/theme/light_theme.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton<Firestore>(() => Firestore.instance);
  locator.registerLazySingleton<DatabaseService>(() => DatabaseService(locator.get()));
}

void main() {
  setupLocator();
  runApp(GarderobelAdmin());
}

class GarderobelAdmin extends StatelessWidget {
  static const String _title = 'Garderobeladmin';

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
        title: _title, theme: lightThemeData(), darkTheme: darkThemeData(), home: Authenticator());

    return MultiProvider(providers: [
      Provider<GetIt>.value(value: locator),
      StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged),
      Provider<AbstractGladminApi>.value(value: LocalGladminApi()),
    ], child: materialApp);
  }
}

class Authenticator extends StatefulWidget {
  Authenticator({Key key}) : super(key: key);

  _AuthenticatorState createState() => _AuthenticatorState();
}

class _AuthenticatorState extends State<Authenticator> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return SignIn();
    } else {
      return TabBarController();
    }
  }

  void _checkCurrentUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);
    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }
}

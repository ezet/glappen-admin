import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garderobeladmin/services/locator.dart';
import 'package:garderobeladmin/ui/sign_in.dart';
import 'package:garderobeladmin/ui/venue_selector.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'ui/theme/dark_theme.dart';
import 'ui/theme/light_theme.dart';

void main() {
  runApp(
    GarderobelAdmin(),
  );
}

class GarderobelAdmin extends StatelessWidget {
  static const String _title = 'Garderobeladmin';

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
        title: _title, theme: lightThemeData(), darkTheme: darkThemeData(), home: Authenticator());

    return MultiProvider(providers: [
      Provider<GetIt>.value(value: getLocator(context)),
      StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged),
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
      return VenueSelector();
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

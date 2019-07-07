import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'models/device.dart';
import 'models/section.dart';
import 'models/user.dart';
import 'models/venue.dart';
import 'services/api.dart';
import 'services/locator.dart';
import 'ui/bottombar/tab_bar_controller.dart';
import 'ui/sign_in.dart';
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
      title: _title,
      theme: lightThemeData(),
      darkTheme: darkThemeData(),
      home: Authenticator(),
//      initialRoute: Authenticator.routeName,
    );

    return MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged),
          Provider<GetIt>.value(value: getLocator(context)),
        ],
        child: Consumer<GetIt>(
          builder: (_, getIt, widget) => StreamProvider<Device>.value(
              value: getIt.get<GladminApi>().getDevice('kEPiq0dXzA3uRIoyaGDC'),
              child: Consumer<Device>(
                  builder: (context, device, child) => MultiProvider(
                        providers: [
                          StreamProvider<Venue>.value(value: device?.getVenue()),
                          StreamProvider<Section>.value(value: device?.getSection()),
                        ],
                        child: materialApp,
                      ))),
        ));
  }
}

class Authenticator extends StatefulWidget {
  static const routeName = '/';

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
      final api = Provider.of<GetIt>(context).get<GladminApi>();
      final user = User(
          docId: _currentUser.uid,
          name: _currentUser.displayName,
          email: _currentUser.email,
          phone: _currentUser.phoneNumber,
          photoUrl: _currentUser.photoUrl);
      api.updateUser(user);

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

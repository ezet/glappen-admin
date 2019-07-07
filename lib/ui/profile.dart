import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/user.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final String _userId;

  Profile(this._userId);

  Widget build(BuildContext context) {
    final GladminApi db = Provider.of<GetIt>(context).get();

    return StreamProvider<User>.value(value: db.getUser(_userId), child: ProfileData());
  }
}

class ProfileData extends StatelessWidget {
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    // TODO: implement profile UI
    return Scaffold(
      appBar: AppBar(
        title: Text(_user?.name ?? ""),
      ),
      body: Center(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:garderobeladmin/ui/settings/manage_venue.dart';

class VenueSettingsView extends StatelessWidget {
  const VenueSettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Wardrobes"),
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageVenue())),
        )
      ],
    );
  }
}

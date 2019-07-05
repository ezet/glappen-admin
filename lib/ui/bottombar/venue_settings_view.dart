import 'package:flutter/material.dart';
import 'package:garderobeladmin/ui/settings/edit_venue_screen.dart';
import 'package:garderobeladmin/ui/settings/manage_venue.dart';

class VenueSettingsView extends StatelessWidget {
  const VenueSettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Details"),
          subtitle: Text("Edit venue details and information"),
          leading: Icon(Icons.info),
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditVenueScreen())),
        ),
        ListTile(
          title: Text("Wardrobes"),
          subtitle: Text("Manage your wardrobes and sections"),
          leading: Icon(Icons.accessibility_new),
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageVenue())),
        ),
        ListTile(
          title: Text("Payment options"),
          subtitle: Text("Manage your payment options"),
          leading: Icon(Icons.credit_card),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:garderobeladmin/ui/wardrobe_view.dart';

class VenueSettingsView extends StatelessWidget {
  const VenueSettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text("Wardrobes"),
      onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => WardrobeView())),
    );
  }
}

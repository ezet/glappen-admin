import 'package:flutter/material.dart';
import 'package:garderobeladmin/data/db.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/ui/tab_bar_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class VenueSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: There is probably a more idiomatic way to do this
    final DatabaseService dbService = Provider.of<GetIt>(context).get();
    var venue = dbService.getVenue('KREps4urlJ9Ymy6g9VdY');

    return StreamProvider<Venue>.value(value: venue, child: TabBarController());
  }
}

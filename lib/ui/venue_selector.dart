import 'package:flutter/material.dart';
import 'package:garderobeladmin/data/db.dart';
import 'package:garderobeladmin/models/device.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/ui/tab_bar_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class VenueSelector extends StatelessWidget {
  const VenueSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService dbService = Provider.of<GetIt>(context).get();
    // TODO: read device ID from hardware
    final device = dbService.getDevice('kEPiq0dXzA3uRIoyaGDC');
    return StreamProvider<Device>.value(
        value: device,
        child: Consumer<Device>(
            builder: (context, device, child) => MultiProvider(
                  providers: [
                    StreamProvider<Venue>.value(value: device?.getVenue()),
                    StreamProvider<Section>.value(value: device?.getSection()),
                  ],
                  child: TabBarController(),
                )));
  }
}

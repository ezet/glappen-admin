import 'package:flutter/material.dart';
import 'package:garderobeladmin/data/db.dart';
import 'package:garderobeladmin/models/device.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/models/wardrobe.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

mixin ModelMixin on StatelessWidget {
  buildProvider(BuildContext context, Widget widget) {
    final DatabaseService dbService = Provider.of<GetIt>(context).get();
    // TODO: read device ID from hardware
    final device = dbService.getDevice('kEPiq0dXzA3uRIoyaGDC');
    return StreamProvider<Device>.value(
        value: device,
        child: Consumer<Device>(
          builder: (context, device, child) => StreamProvider<Venue>.value(
                value: device?.getVenue(),
                child: Consumer<Venue>(
                    builder: (context, venue, child) => StreamProvider<List<Wardrobe>>.value(
                          value: venue?.getWardrobes(),
                          child: widget,
                        )),
              ),
        ));
  }
}

class WardrobeView extends StatelessWidget with ModelMixin {
  const WardrobeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildProvider(
        context,
        Scaffold(
          appBar: AppBar(title: Text("Title")),
          body: WardrobeList(),
        ));
  }
}

class WardrobeList extends StatelessWidget {
  const WardrobeList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wardrobes = Provider.of<List<Wardrobe>>(context);
    if (wardrobes == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemBuilder: (context, position) => _buildRow(wardrobes[position]),
      itemCount: wardrobes.length,
    );
  }

  Widget _buildRow(Wardrobe wardrobe) {
    return Text(wardrobe?.name ?? "");
  }
}

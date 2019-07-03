import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/models/wardrobe.dart';
import 'package:provider/provider.dart';

import 'edit_wardrobe_screen.dart';
import 'manage_sections_screen.dart';

class ManageVenue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final venue = Provider.of<Venue>(context);
    return StreamProvider<List<Wardrobe>>.value(
        value: venue?.getWardrobes(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Wardrobes"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditWardrobeScreen(), fullscreenDialog: true)),
              ),
            ],
          ),
          body: WardrobeList(),
        ));
  }
}

enum ConfirmAction { CANCEL, DELETE }

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
      itemBuilder: (context, position) => _buildRow(context, wardrobes[position]),
      itemCount: wardrobes.length,
    );
  }

  Widget _buildRow(BuildContext context, Wardrobe wardrobe) {
    return ListTile(
      title: Text(wardrobe?.name ?? ""),
      onLongPress: () => _showDeleteDialog(context, wardrobe),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => SectionsView(wardrobe))),
    );
  }

  _showDeleteDialog(BuildContext context, Wardrobe wardrobe) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete wardrobe"),
            content: Text("Do you want to delete this wardrobe?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, ConfirmAction.CANCEL);
                  },
                  child: Text("CANCEL")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, ConfirmAction.DELETE);
                  },
                  child: Text("DELETE"))
            ],
          );
        });
    if (result == ConfirmAction.DELETE) {
      await wardrobe.delete();
    }
  }
}

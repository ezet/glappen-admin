import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/wardrobe.dart';
import 'package:provider/provider.dart';

class SectionsView extends StatelessWidget {
  const SectionsView(this._wardrobe, {Key key}) : super(key: key);

  final Wardrobe _wardrobe;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Section>>.value(
        value: _wardrobe?.getSections(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(_wardrobe.name),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => {},
              ),
            ],
          ),
          body: SectionsList(),
        ));
  }
}

class SectionsList extends StatelessWidget {
  const SectionsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = Provider.of<List<Section>>(context);
    if (sections == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemBuilder: (context, position) => _buildRow(sections[position]),
      itemCount: sections.length,
    );
  }

  Widget _buildRow(Section section) {
    return ListTile(
      title: Text(section?.name ?? ""),
      onTap: () => {},
    );
  }
}

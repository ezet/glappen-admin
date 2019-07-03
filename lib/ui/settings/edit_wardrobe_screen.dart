import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/models/wardrobe.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class EditWardrobeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Add wardrobe")), body: EditWardrobeForm());
  }
}

class EditWardrobeForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditWardrobeFormState();
}

class EditWardrobeFormState extends State<EditWardrobeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final formData = WardrobeFormData();

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<GetIt>(context).get<GladminApi>();

    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter some text';
                }
                return null;
              },
              onSaved: (val) => formData.name = val,
              decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Enter the wardrobe name",
                  icon: Icon(Icons.edit_attributes)),
            ),
            TextFormField(
              onSaved: (val) => formData.color = val,
              decoration: InputDecoration(
                  labelText: "Color",
                  hintText: "Provide a color for the wardrobe",
                  icon: Icon(Icons.color_lens)),
            ),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (val) => int.tryParse(val) != null ? null : "Invalid price",
              onSaved: (val) => formData.price = int.tryParse(val),
              decoration: InputDecoration(
                  labelText: "Price",
                  hintText: "Enter the price for checking a single item",
                  icon: Icon(Icons.attach_money)),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      final venue = Provider.of<Venue>(context);
                      final result = await venue.addWardrobe(Wardrobe(
                          name: formData.name, color: formData.color, price: formData.price));
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Wardrobe added ")));
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add"),
                ))
          ],
        ),
      ),
    );
  }
}

class WardrobeFormData {
  String name;
  String color;
  int price;
}

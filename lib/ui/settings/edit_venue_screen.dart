import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:provider/provider.dart';

class EditVenueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Edit venue")), body: EditVenueForm());
  }
}

class EditVenueForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditVenueFormState();
}

class EditVenueFormState extends State<EditVenueForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final formData = VenueFormData();

  @override
  Widget build(BuildContext context) {
    final venue = Provider.of<Venue>(context);

    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            TextFormField(
              initialValue: venue.name,
              validator: (value) => value.isEmpty ? "Enter some text" : null,
              onSaved: (val) => formData.name = val,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Enter the wardrobe name",
                  icon: Icon(Icons.edit_attributes)),
            ),
            TextFormField(
              initialValue: venue.email,
              validator: (value) => value.isEmpty ? "Enter some text" : null,
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => formData.email = val,
              decoration: InputDecoration(
                  labelText: "Email", hintText: "Contact email", icon: Icon(Icons.email)),
            ),
            TextFormField(
              initialValue: venue.url,
              keyboardType: TextInputType.url,
              onSaved: (val) => formData.url = val,
              decoration: InputDecoration(
                  labelText: "Website", hintText: "The venue website", icon: Icon(Icons.web)),
            ),
            TextFormField(
              initialValue: venue.logo,
              keyboardType: TextInputType.url,
              onSaved: (val) => formData.logo = val,
              decoration: InputDecoration(
                  labelText: "Logo", hintText: "The venue logo", icon: Icon(Icons.image)),
            ),
            TextFormField(
              initialValue: venue.city,
              keyboardType: TextInputType.text,
              onSaved: (val) => formData.city = val,
              decoration: InputDecoration(
                  labelText: "City",
                  hintText: "City of the venue",
                  icon: Icon(Icons.location_city)),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      final venue = Provider.of<Venue>(context);
                      final result = await venue.updateDetails(Venue(
                          name: formData.name,
                          email: formData.email,
                          url: formData.url,
                          city: formData.city,
                          logo: formData.logo));
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Venue updated")));
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Save"),
                ))
          ],
        ),
      ),
    );
  }
}

class VenueFormData {
  String email;
  String location;
  String logo;
  String name;
  String url;
  String city;
}

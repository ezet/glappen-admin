import 'package:cloud_firestore/cloud_firestore.dart';

class Wardrobe {
  final String name;
  final String color;

  Wardrobe({this.name, this.color});

  factory Wardrobe.fromFirestore(DocumentSnapshot snapshot) {
    return Wardrobe(name: snapshot.data['name'], color: snapshot.data['color']);
  }
}

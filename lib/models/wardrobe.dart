import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/section.dart';

class Wardrobe {
  final String name;
  final String color;
  final int price;
  final CollectionReference sections;
  final DocumentReference ref;

  static const jsonName = "name";
  static const jsonColor = "color";
  static const jsonPrice = "price";
  static const jsonSection = "section";

  Wardrobe({this.name, this.color, this.price, this.sections, this.ref});

  factory Wardrobe.fromFirestore(DocumentSnapshot snapshot) {
    return Wardrobe(
        ref: snapshot.reference,
        name: snapshot.data[jsonName],
        color: snapshot.data[jsonColor],
        price: snapshot.data[jsonPrice],
        sections: snapshot.reference.collection(jsonSection));
  }

  Stream<List<Section>> getSections() {
    return sections
        .snapshots()
        .map((snapshot) => snapshot.documents.map((e) => Section.fromFirestore(e)).toList());
  }

  Map<String, dynamic> toFirestore() {
    return {jsonName: name, jsonPrice: price, jsonColor: color};
  }

  Future<void> delete() async {
    return ref.delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/wardrobe.dart';

class Venue {
  final String id;
  final String name;
  final String email;
  final String city;
  final String logo;
  final String url;
  final CollectionReference wardrobes;
  final DocumentReference _ref;

  Venue(this._ref,
      {this.id, this.name, this.email, this.city, this.logo, this.url, this.wardrobes});

  factory Venue.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Venue(doc.reference,
        id: doc.documentID,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        city: data['city'] ?? '',
        logo: data['logo'] ?? '',
        url: data['url'] ?? '',
        wardrobes: doc.reference.collection('wardrobes'));
  }

  Stream<List<Wardrobe>> getWardrobes() {
    return wardrobes
        .snapshots()
        .map((list) => list.documents.map((item) => Wardrobe.fromFirestore(item)).toList());
  }

  Future<DocumentReference> addWardrobe(Wardrobe wardrobe) async {
    return wardrobes.add(wardrobe.toFirestore());
  }
}

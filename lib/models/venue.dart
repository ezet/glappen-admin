import 'package:cloud_firestore/cloud_firestore.dart';

class Venue {
  final String id;
  final String name;
  final String email;
  final String city;
  final String logo;
  final String url;

  Venue({
    this.id,
    this.name,
    this.email,
    this.city,
    this.logo,
    this.url,
  });

  factory Venue.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Venue(
      id: doc.documentID,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      city: data['city'] ?? '',
      logo: data['logo'] ?? '',
      url: data['url'] ?? '',
    );
  }
}

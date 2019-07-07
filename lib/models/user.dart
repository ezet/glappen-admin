import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String docId;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;

  User({
    this.docId,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
  });

  static const jsonName = "name";
  static const jsonEmail = "email";
  static const jsonPhone = "phone";
  static const jsonPhotoUrl = "photoUrl";

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
      docId: doc.documentID,
      name: data[jsonName] ?? '',
      email: data[jsonName] ?? '',
      phone: data[jsonPhone] ?? '',
      photoUrl: data[jsonPhotoUrl] ?? '',
    );
  }
}

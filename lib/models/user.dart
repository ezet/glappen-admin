import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String docId;
  final String name;
  final String email;
  final String phone;
  final String employeeId;

  User({
    this.docId,
    this.name,
    this.email,
    this.phone,
    this.employeeId,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
      docId: doc.documentID,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      employeeId: data['employeeId'] ?? '',
    );
  }
}

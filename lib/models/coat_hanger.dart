import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/user.dart';

class CoatHanger {
  final String docId;
  final String id;
  final DocumentReference user;
  final Timestamp timestamp;

  CoatHanger({
    this.docId,
    this.id,
    this.user,
    this.timestamp,
  });

  factory CoatHanger.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return CoatHanger(
      docId: doc.documentID,
      id: data['id'] ?? null,
      user: data['user'] ?? '',
      timestamp: data['timestamp'] ?? null,
    );
  }

  Stream<User> getUser() => user.snapshots().map((s) => User.fromFirestore(s));
}

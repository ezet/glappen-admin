import 'package:cloud_firestore/cloud_firestore.dart';

class CoatHanger {
  final String docId;
  final int id;
  final String user;
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
}

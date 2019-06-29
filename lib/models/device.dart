import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  final String docId;
  final DocumentReference section;
  final DocumentReference venue;

  Device({this.docId, this.section, this.venue});

  factory Device.fromFirestore(DocumentSnapshot doc, Firestore db) {
    Map data = doc.data;
    final DocumentReference sec = db.document(data['section']);
    return Device(
        docId: doc.documentID, section: sec, venue: sec.parent().parent().parent().parent());
  }
}

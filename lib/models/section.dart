import 'package:cloud_firestore/cloud_firestore.dart';

import 'coat_hanger.dart';

class Section {
  final String docId;
  final CollectionReference hangers;

  Section({this.docId, this.hangers});

  factory Section.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Section(docId: doc.documentID, hangers: data['hangers'] ?? null);
  }

  Stream<List<CoatHanger>> getHangers() {
    return hangers
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)));
  }
}

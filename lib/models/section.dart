import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/wardrobe.dart';

import 'coat_hanger.dart';

class Section {
  final String docId;
  final CollectionReference hangers;
  final DocumentReference wardrobe;

  Section(this.docId, this.hangers, this.wardrobe);

  factory Section.fromFirestore(DocumentSnapshot doc) {
    return Section(
        doc.documentID, doc.reference.collection('hangers'), doc.reference.parent().parent());
  }

  Stream<List<CoatHanger>> getHangers() {
    return hangers
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }

  Stream<Wardrobe> getWardrobe() {
    return wardrobe.snapshots().map((snapshot) => Wardrobe.fromFirestore(snapshot));
  }
}

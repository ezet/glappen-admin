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
        .where('state', isGreaterThanOrEqualTo: HangerState.CHECKING_OUT.index)
        .orderBy('state')
        .orderBy('stateUpdated')
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }

  Stream<List<CoatHanger>> getCheckingIn() {
    return hangers
        .where('reserved', isGreaterThan: Timestamp.fromMicrosecondsSinceEpoch(0))
        .where('claimed', isNull: true)
        .orderBy('reserved')
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }

  Stream<List<CoatHanger>> getCheckingOut() {
    return hangers
        .where('checkout', isGreaterThan: Timestamp.fromMicrosecondsSinceEpoch(0))
        .orderBy('checkout')
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }

  Stream<Wardrobe> getWardrobe() {
    return wardrobe.snapshots().map((snapshot) => Wardrobe.fromFirestore(snapshot));
  }
}

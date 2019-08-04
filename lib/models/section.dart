import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobel_api/models/reservation.dart';
import 'package:garderobeladmin/models/wardrobe.dart';

import 'coat_hanger.dart';

class Section {
  final DocumentReference ref;
  final String docId;
  final String name;
  final CollectionReference hangers;
  final DocumentReference wardrobe;

  Section(this.ref, this.docId, this.name, this.hangers, this.wardrobe);

  factory Section.fromFirestore(DocumentSnapshot doc) {
    return Section(doc.reference, doc.documentID, doc.data['name'],
        doc.reference.collection('hangers'), doc.reference.parent().parent());
  }

  Stream<List<CoatHanger>> getHangers() {
    return hangers
        .orderBy('state')
        .orderBy('stateUpdated')
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }

  DocumentReference get venueRef => ref.parent().parent().parent().parent();

  Stream<List<Reservation>> getReservations() {
    return venueRef.firestore
        .collection('reservations')
        .where(ReservationRef.jsonState,
            isGreaterThanOrEqualTo: ReservationState.CHECKING_OUT.index)
//        .orderBy('state')
//        .orderBy('stateUpdated')
        .snapshots()
        .handleError(() => print("error"))
        .map((list) => list.documents.map((doc) => ReservationRef.fromFirestore(doc)).toList());
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

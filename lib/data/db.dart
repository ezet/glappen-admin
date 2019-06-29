import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/venue.dart';

class DatabaseService {
  DatabaseService(Firestore db) : _db = db;

  final Firestore _db;

  Stream<List<CoatHanger>> getCheckInList(String venueId) {
    var ref = _db.collection('venues').document(venueId).collection('hangers');
    return ref
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }

  Stream<List<CoatHanger>> getCheckOutList(String venueId) {
    var ref = _db.collection('venues').document(venueId).collection('hangers');
    return ref
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }

  Stream<Venue> getVenue(String venueId) {
    var ref = _db.collection('venues').document(venueId);
    return ref.snapshots().map((venue) => Venue.fromFirestore(venue));
  }
}

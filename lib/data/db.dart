import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<CoatHanger>> streamHangers(String venueId) {
    var ref = _db.collection('venues').document(venueId).collection('hangers');
    return ref
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }
}

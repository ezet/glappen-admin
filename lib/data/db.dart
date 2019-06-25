import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:provider/provider.dart';

class DatabaseService extends InheritedWidget {
  Firestore _db;

  Stream<List<CoatHanger>> streamHangers(String venueId) {
    var ref = _db.collection('venues').document(venueId).collection('hangers');
    return ref
        .snapshots()
        .map((list) => list.documents.map((doc) => CoatHanger.fromFirestore(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    _db = Provider.of<Firestore>(context);
    return null;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

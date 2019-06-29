import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/device.dart';
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

  Stream<Device> getDevice(String deviceId) {
    // TODO: handle single error
    var ref = _db.collection('devices').document(deviceId);
    return ref.snapshots().map((snapshot) => Device.fromFirestore(snapshot));
  }

  Stream<Venue> getVenueForDevice(String deviceId) {
    // TODO: handle single error
    var ref = _db.collectionGroup('devices').where('id', isEqualTo: deviceId);
    return ref
        .snapshots()
        .asyncMap(
            (devicesSnapshot) => devicesSnapshot.documents.single.reference.parent().parent().get())
        .map((venue) => Venue.fromFirestore(venue));
  }

  Stream<Venue> getSectionForDevice(String deviceId) {
    // TODO: handle single error
    var ref = _db.collectionGroup('devices').where('id', isEqualTo: deviceId);
    return ref
        .snapshots()
        .asyncMap((venue) => venue.documents.single.reference.parent().parent().get())
        .map((venue) => Venue.fromFirestore(venue));
  }
}

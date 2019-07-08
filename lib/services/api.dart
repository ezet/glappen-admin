import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/device.dart';
import 'package:garderobeladmin/models/reservation.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/user.dart';
import 'package:garderobeladmin/models/venue.dart';

abstract class GladminApi {
  Future simulateCheckInScan(Venue venue, Section section, FirebaseUser user);

  Future simulateCheckOutScan(Venue venue, Section section, FirebaseUser user);

  Stream<Device> getDevice(String deviceId);

  Stream<User> getUser(String userId);

  void updateUser(User user);

  getReservation(String reservationId) {}
}

class LocalGladminApi implements GladminApi {
  static const pathUsers = 'users';

  LocalGladminApi(this._db);

  // ignore: unused_field
  final Firestore _db;

  Stream<Device> getDevice(String deviceId) {
    // TODO: handle single error
    var ref = _db.collection('devices').document(deviceId);
    return ref.snapshots().map((snapshot) => Device.fromFirestore(snapshot));
  }

  Stream<User> getUser(String userId) {
    // TODO: handle single error
    var ref = _db.collection('users').document(userId);
    return ref.snapshots().map((snapshot) => User.fromFirestore(snapshot));
  }

  Future<bool> _updateHangerState(CoatHanger hanger, HangerState state) async {
    return hanger.ref.setData({'stateUpdated': FieldValue.serverTimestamp(), 'state': state.index},
        merge: true).then((value) => true, onError: (error) {
      print(error);
      return false;
    });
  }

  @override
  simulateCheckInScan(Venue venue, Section section, FirebaseUser user) async {
    final hangers = await section.hangers
        .where('state', isEqualTo: HangerState.AVAILABLE.index)
        .limit(1)
        .getDocuments();
    DocumentReference hangerRef;
    if (hangers.documents.isEmpty) {
      hangerRef = await section.hangers.add({
        'id': Random().nextInt(9999).toString(),
        'state': HangerState.UNAVAILABLE.index,
        'stateUpdated': FieldValue.serverTimestamp(),
        'user': _db.collection(pathUsers).document(user.uid)
      });
    } else {
      hangerRef = hangers.documents.first.reference;
      hangerRef.setData({
        'state': HangerState.UNAVAILABLE.index,
        'stateUpdated': FieldValue.serverTimestamp(),
      }, merge: true);
    }

    final userRef = _db.collection(pathUsers).document(user.uid);

    final hangerName = await hangerRef.get().then((item) => item.data[CoatHanger.jsonId]);
    final userName = await userRef.get().then((item) => item.data[User.jsonName]);

    await venue.reservations.add({
      Reservation.jsonSection: section.ref,
      Reservation.jsonHanger: hangerRef,
      Reservation.jsonHangerName: hangerName,
      Reservation.jsonUser: userRef,
      Reservation.jsonUserName: userName,
      Reservation.jsonState: ReservationState.CHECKING_IN.index,
      Reservation.jsonReservationTime: FieldValue.serverTimestamp(),
    });
  }

  @override
  simulateCheckOutScan(Venue venue, Section section, FirebaseUser user) async {
    final reservations = await venue.reservations
        .where(Reservation.jsonSection, isEqualTo: section.ref)
        .where(Reservation.jsonState, isEqualTo: ReservationState.CHECKED_IN.index)
        .where(Reservation.jsonUser, isEqualTo: _db.collection(pathUsers).document(user.uid))
        .getDocuments();
    if (reservations.documents.isEmpty) {
      return Future(() => false);
    }
    await reservations.documents.first.reference.updateData({
      Reservation.jsonStateUpdated: FieldValue.serverTimestamp(),
      Reservation.jsonState: ReservationState.CHECKING_OUT.index
    });
  }

  @override
  void updateUser(User user) async {
    return _db.collection(pathUsers).document(user.docId).setData(toFirebase(user), merge: true);
  }

  Map<String, dynamic> toFirebase(User user) {
    return {
      User.jsonPhotoUrl: user.photoUrl,
      User.jsonPhone: user.phone,
      User.jsonName: user.name,
      User.jsonEmail: user.email
    };
  }

  @override
  getReservation(String reservationId) {
    // TODO: implement getReservation
    return null;
  }
}

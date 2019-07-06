import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/device.dart';
import 'package:garderobeladmin/models/reservation.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/user.dart';
import 'package:garderobeladmin/models/venue.dart';

abstract class GladminApi {
  Future<bool> confirmUpdate(CoatHanger hanger);

  Future<bool> rejectUpdate(CoatHanger hanger);

  Future simulateCheckInScan(Venue venue, Section section);

  Future simulateCheckOutScan(Venue venue, Section section);

  Stream<Device> getDevice(String deviceId);

  Stream<User> getUser(String userId);
}

class LocalGladminApi implements GladminApi {
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

  @override
  confirmUpdate(CoatHanger hanger) async {
    if (hanger.state == HangerState.CHECKING_IN) {
      // TODO: create reservation
      return _updateHangerState(hanger, HangerState.TAKEN);
    } else {
      // TODO: update reservation
      return _updateHangerState(hanger, HangerState.AVAILABLE);
    }
  }

  @override
  rejectUpdate(CoatHanger hanger) async {
    // TODO: update reservation
    if (hanger.state == HangerState.CHECKING_IN) {
//      hanger.createReservation();
      return _updateHangerState(hanger, HangerState.AVAILABLE);
    } else {
      return _updateHangerState(hanger, HangerState.TAKEN);
    }
  }

  Future<bool> _updateHangerState(CoatHanger hanger, HangerState state) async {
    return hanger.ref.setData({'stateUpdated': FieldValue.serverTimestamp(), 'state': state.index},
        merge: true).then((value) => true, onError: (error) {
      print(error);
      return false;
    });
  }

  @override
  simulateCheckInScan(Venue venue, Section section) async {
    final hangers = await section.hangers
        .where('state', isEqualTo: HangerState.AVAILABLE.index)
        .limit(1)
        .getDocuments();
    DocumentReference hangerRef;
    if (hangers.documents.isEmpty) {
      hangerRef = await section.hangers.add({
        'id': Random().nextInt(9999).toString(),
        'state': HangerState.CHECKING_IN.index,
        'stateUpdated': FieldValue.serverTimestamp(),
        'user': _db.document('/users/TCaRw69hRNRlwhXvfCPYYt3XaJx1')
      });
    } else {
      hangerRef = hangers.documents.first.reference;
      hangerRef.setData({
        'state': HangerState.CHECKING_IN.index,
        'stateUpdated': FieldValue.serverTimestamp(),
        'user': _db.document('/users/TCaRw69hRNRlwhXvfCPYYt3XaJx1')
      }, merge: true);
    }

    final userRef = _db.document('/users/TCaRw69hRNRlwhXvfCPYYt3XaJx1');

    final hangerName = await hangerRef.get().then((item) => item.data[CoatHanger.jsonId]);
    final userName = await userRef.get().then((item) => item.data[User.jsonName]);

    await venue.reservations.add({
      Reservation.jsonSection: section.ref,
      Reservation.jsonHanger: hangerRef,
      Reservation.jsonHangerName: hangerName,
      Reservation.jsonUser: userRef,
      Reservation.jsonReservationTime: FieldValue.serverTimestamp(),
    });
  }

  @override
  simulateCheckOutScan(Venue venue, Section section) async {
    final hangers = await section.hangers
        .where('state', isEqualTo: HangerState.TAKEN.index)
        .limit(1)
        .getDocuments();
    if (hangers.documents.isNotEmpty) {
      final hanger = hangers.documents.first;
      hanger.reference.updateData({
        'state': HangerState.CHECKING_OUT.index,
        'stateUpdated': FieldValue.serverTimestamp(),
      });
    }
  }
}

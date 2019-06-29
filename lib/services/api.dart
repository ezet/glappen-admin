import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/section.dart';

abstract class GladminApi {
  void scan(int code);

  Future<bool> confirmCheckIn(CoatHanger hanger);

  Future<bool> confirmCheckOut(CoatHanger hanger);

  Future simulateCheckInScan(Section section);

  Future simulateCheckOutScan(Section section);
}

class LocalGladminApi implements GladminApi {
  LocalGladminApi(this._db);

  // ignore: unused_field
  final Firestore _db;

  void scan(int venueId) {
    if (_hasActiveReservation()) {
      _checkout();
    } else {
      _checkIn();
    }
  }

  bool _hasActiveReservation() {
    return true;
  }

  void _checkIn() {}

  void _checkout() {}

  @override
  confirmCheckIn(CoatHanger hanger) async {
    if (hanger.state == HangerState.CHECKING_IN)
      return _updateHangerState(hanger, HangerState.TAKEN);
    else {
      return _updateHangerState(hanger, HangerState.AVAILABLE);
    }
  }

  @override
  confirmCheckOut(CoatHanger hanger) async {
    if (hanger.state == HangerState.CHECKING_IN)
      return _updateHangerState(hanger, HangerState.AVAILABLE);
    else {
      return _updateHangerState(hanger, HangerState.TAKEN);
    }
  }

  Future<bool> _updateHangerState(CoatHanger hanger, HangerState state) async {
    return hanger.ref.setData({'stateUpdated': FieldValue.serverTimestamp(), 'state': state.index},
        merge: true).then((value) => true, onError: (error) {
      print(error);
      return false;
    }).whenComplete(() => print("Done"));
  }

  @override
  simulateCheckInScan(Section section) async {
    section.hangers.add({
      'id': Random().nextInt(9999).toString(),
      'state': HangerState.CHECKING_IN.index,
      'stateUpdated': FieldValue.serverTimestamp(),
      'user': _db.document('/users/TCaRw69hRNRlwhXvfCPYYt3XaJx1')
    });
  }

  @override
  simulateCheckOutScan(Section section) async {
    section.hangers.add({
      'id': Random().nextInt(9999).toString(),
      'state': HangerState.CHECKING_OUT.index,
      'stateUpdated': FieldValue.serverTimestamp(),
      'user': _db.document('/users/TCaRw69hRNRlwhXvfCPYYt3XaJx1')
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';

abstract class GladminApi {
  void scan(int code);

  Future<bool> confirmCheckIn(CoatHanger hanger);

  Future<bool> confirmCheckOut(CoatHanger hanger);
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
    // TODO: replace with HangerState.TAKEN
    if (hanger.state == HangerState.CHECKING_IN)
      return _updateHangerState(hanger, HangerState.CHECKING_OUT);
    else {
      return _updateHangerState(hanger, HangerState.CHECKING_IN);
    }
  }

  @override
  confirmCheckOut(CoatHanger hanger) async {
    return Future(() => false);
    if (hanger.state == HangerState.CHECKING_IN)
      // TODO: replace with HangerState.AVAILABLE
      return _updateHangerState(hanger, HangerState.CHECKING_OUT);
    else {
      return _updateHangerState(hanger, HangerState.CHECKING_IN);
    }
  }

  Future<bool> _updateHangerState(CoatHanger hanger, HangerState state) async {
    return hanger.ref.setData({'stateUpdated': FieldValue.serverTimestamp(), 'state': state.index},
        merge: true).then((value) => true, onError: (error) {
      print(error);
      return false;
    }).whenComplete(() => print("Done"));
  }
}

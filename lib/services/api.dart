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
    return true;
  }

  @override
  confirmCheckOut(CoatHanger hanger) async {
    return true;
  }
}

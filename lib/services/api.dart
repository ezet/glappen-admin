import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';

abstract class GladminApi {
  void scan(int code);

  void confirmCheckIn();

  void confirmCheckOut(CoatHanger hanger);
}

class LocalGladminApi implements GladminApi {
  LocalGladminApi(this._firestore);

  final Firestore _firestore;

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

  void confirmCheckIn() {}

  void confirmCheckOut(CoatHanger hanger) {}
}

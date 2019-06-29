import 'package:garderobeladmin/data/db.dart';

abstract class GladminApi {
  void scan(int code);

  void confirmCheckin();

  void confirmCheckout();
}

class LocalGladminApi implements GladminApi {
  LocalGladminApi(this._databaseService);

  final DatabaseService _databaseService;

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

  void confirmCheckin() {}

  void confirmCheckout() {}
}

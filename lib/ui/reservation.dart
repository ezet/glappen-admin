import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/reservation.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ReservationDetailArguments {
  final String reservationId;

  ReservationDetailArguments({@required this.reservationId});
}

class ReservationDetails extends StatelessWidget {
  final String _reservationId;

  static const routeName = '/reservation';

  static MaterialPageRoute route({@required String reservationId}) {
    return MaterialPageRoute(builder: (context) => ReservationDetails(reservationId));
  }

  ReservationDetails(this._reservationId);

  Widget build(BuildContext context) {
    final api = Provider.of<GetIt>(context).get<GladminApi>();
    return StreamProvider<Reservation>.value(
        value: api.getReservation(_reservationId), child: ProfileData());
  }
}

class ProfileData extends StatelessWidget {
  Widget build(BuildContext context) {
    final reservation = Provider.of<Reservation>(context);
    // TODO: implement profile UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation"),
      ),
      body: Center(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:garderobel_api/models/reservation.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ReservationDetails extends StatelessWidget {
  final String _reservationId;

  static const routeName = '/reservation';

  static MaterialPageRoute route({@required String reservationId}) {
    return MaterialPageRoute(builder: (context) => ReservationDetails(reservationId));
  }

  ReservationDetails(this._reservationId);

  Widget build(BuildContext context) {
    final api = Provider.of<GetIt>(context).get<GladminService>();
    return StreamProvider<Reservation>.value(
        value: api.getReservation(_reservationId), child: ProfileData());
  }
}

class ProfileData extends StatelessWidget {
  Widget build(BuildContext context) {
    final reservation = Provider.of<Reservation>(context);
    // TODO Andreas: implement profile UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation"),
      ),
      body: Center(child: Text("TODO: Sondre")),
    );
  }
}

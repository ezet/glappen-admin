import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/reservation.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class Reservations extends StatelessWidget {
  const Reservations({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final venue = Provider.of<Venue>(context);

    return StreamProvider<List<Reservation>>.value(
        value: venue?.getReservations(), child: ReservationList());
  }
}

class ReservationList extends StatelessWidget {
  const ReservationList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<GetIt>(context).get<GladminApi>();

    var reservations = Provider.of<List<Reservation>>(context);
    if (reservations == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemCount: reservations.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
            height: 30,
            color: Colors.transparent,
          ),
      itemBuilder: (context, i) {
        return buildCheckInItem(context, reservations, i, api);
      },
    );
  }

  Widget buildCheckInItem(BuildContext context, List<Reservation> hangers, int i, GladminApi api) {
    return Text("Res");
  }
}

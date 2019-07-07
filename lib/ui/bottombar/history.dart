import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/reservation.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  const History({Key key}) : super(key: key);

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
    var reservations = Provider.of<List<Reservation>>(context);
    if (reservations == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.separated(
//      padding: EdgeInsets.all(10),
      itemCount: reservations.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
            color: Colors.grey,
          ),
      itemBuilder: (context, i) {
        return buildCheckInItem(context, reservations[i]);
      },
    );
  }

  Widget buildCheckInItem(BuildContext context, Reservation reservation) {
    return Container(
//        color: Color.fromRGBO(27, 31, 34, 1),
        child: InkWell(
            child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Text("res"),
    )));
  }
}

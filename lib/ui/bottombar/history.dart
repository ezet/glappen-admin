import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/reservation.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/ui/reservation.dart';
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
    return ListView.builder(
//      padding: EdgeInsets.all(10),
      itemCount: reservations.length,
      itemBuilder: (context, i) {
        return buildCheckInItem(context, reservations[i]);
      },
    );
  }

  Widget buildCheckInItem(BuildContext context, Reservation reservation) {
    final makeListTile = ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        onTap: () =>
            Navigator.push(context, ReservationDetails.route(reservationId: reservation.docId)),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.receipt, color: Colors.white),
        ),
        title: Text(
          reservation.userName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Icon(Icons.linear_scale, color: Colors.yellowAccent),
            Text(" ${reservation.hangerName}", style: TextStyle(color: Colors.white))
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));

    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile,
      ),
    );
  }
}

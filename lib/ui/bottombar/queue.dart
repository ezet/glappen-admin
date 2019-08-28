import 'package:flutter/material.dart';
import 'package:garderobel_api/models/reservation.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:garderobeladmin/services/locator.dart';
import 'package:provider/provider.dart';

import '../reservation.dart';

class Queue extends StatelessWidget {
  const Queue({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final section = Provider.of<Section>(context);

    return StreamProvider<List<Reservation>>.value(
        value: section?.getReservations(), child: CoatHangerList());
  }
}

class CoatHangerList extends StatelessWidget {
  const CoatHangerList({
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
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: ListView.separated(
            padding: EdgeInsets.all(10),
            itemCount: reservations.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 20,
              color: Colors.transparent,
            ),
            itemBuilder: (context, i) {
              if (reservations[i].state == ReservationState.CHECKING_IN) {
                return _buildCheckInItem(context, reservations[i]);
              } else {
                return _buildCheckOutItem(context, reservations[i]);
              }
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.3),
          ),
        )
      ],
    );
  }

  Widget _buildCheckInItem(BuildContext context, Reservation reservation) {
    final api = locator.get<GladminService>();
    final makeListTile = ListTile(
//        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        onTap: () =>
            Navigator.push(context, ReservationDetails.route(reservationId: reservation.docId)),
//        leading: Container(
//          padding: EdgeInsets.only(right: 12.0),
//          decoration: new BoxDecoration(
//              border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
//          child: Icon(Icons.receipt, color: Colors.white),
//        ),
        title: Text(
          reservation.userName ?? "",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
//            Icon(Icons.zoom_out_map, color: Colors.yellowAccent),
            Text(
              reservation.hangerName,
            )
          ],
        ),
        trailing: Container(
            child: InkWell(
          onTap: () async {
            api.confirmCheckIn(reservation);
          },
          child: Icon(
            Icons.check_circle,
            color: Color.fromRGBO(105, 212, 103, 1),
            size: 33,
          ),
        )));

    return Card(
      elevation: 5.0,
      color: Color.fromRGBO(27, 31, 34, 1),
      child: makeListTile,
    );
  }

  Widget _buildCheckOutItem(
    BuildContext context,
    Reservation reservation,
  ) {
    final api = locator.get<GladminService>();
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Color.fromRGBO(27, 31, 34, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        border:
            Border.all(color: Color.fromRGBO(66, 74, 82, 1), width: 1.0, style: BorderStyle.solid),
        /*boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 147, 255, .10),
            blurRadius: 6,
          ),
        ],*/
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 1,
                    color: Color.fromRGBO(66, 74, 82, 1),
                  ),
                ),
              ),
              child: InkWell(
                onTap: () => Navigator.push(
                    context, ReservationDetails.route(reservationId: reservation.docId)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      reservation.state == ReservationState.CHECKING_OUT ? "OUT" : "IN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      reservation.hangerName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      reservation.userName ?? "",
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                color: Color.fromRGBO(17, 21, 24, 1),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  splashColor: Color.fromRGBO(105, 212, 103, 1),
                  onTap: () async {
                    api.confirmCheckOut(reservation);
                  },
                  child: Container(
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Color.fromRGBO(105, 212, 103, 1),
                        size: 33,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

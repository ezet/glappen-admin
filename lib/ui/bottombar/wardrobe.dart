import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/reservation.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/venue.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:garderobeladmin/ui/profile.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class WardrobeQueueScreen extends StatelessWidget {
  const WardrobeQueueScreen({Key key}) : super(key: key);

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
    final api = Provider.of<GetIt>(context).get<GladminApi>();

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
                return _buildCheckInItem(context, reservations, i, api);
              } else {
                return _buildCheckOutItem(context, reservations, i, api);
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

  Container _buildCheckInItem(
      BuildContext context, List<CoatHanger> hangers, int i, GladminApi api) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(47, 51, 54, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        border: Border.all(
          color: Colors.amber,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      height: 200,
    );
  }

  Container _buildCheckOutItem(
      BuildContext context, List<Reservation> reservations, int i, GladminApi api) {
    final venue = Provider.of<Venue>(context);
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Color.fromRGBO(27, 31, 34, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        border: Border.all(
            color: Color.fromRGBO(66, 74, 82, 1),
            width: 1.0,
            style: BorderStyle.solid),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*Text(
                    hangers[i].state == HangerState.CHECKING_OUT ? "OUT" : "IN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),*/
                  Text(
                    hangers[i].id.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  StreamBuilder<User>(
                      stream: hangers[i].getUser(),
                      builder: (context, userSnapshot) => InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Profile(userSnapshot.data.docId))),
                            child: Text(
                              userSnapshot.data?.name ?? "",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ))
                ],
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
                    venue.handleConfirmation(reservations[i]);
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

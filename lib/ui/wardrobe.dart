import 'package:flutter/material.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/user.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:garderobeladmin/ui/profile.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class Wardrobe extends StatelessWidget {
  const Wardrobe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final section = Provider.of<Section>(context);

    return StreamProvider<List<CoatHanger>>.value(
        value: section?.getHangers(), child: CoatHangerList());
  }
}

class CoatHangerList extends StatelessWidget {
  const CoatHangerList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<GetIt>(context).get<GladminApi>();

    var hangers = Provider.of<List<CoatHanger>>(context);
    if (hangers == null) {
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
            itemCount: hangers.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 20,
                  color: Colors.transparent,
                ),
            itemBuilder: (context, i) {
              if (hangers[i].state == HangerState.CHECKING_IN) {
                return _buildCheckInItem(context, hangers, i, api);
              } else {
                return _buildCheckOutItem(context, hangers, i, api);
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
      BuildContext context, List<CoatHanger> hangers, int i, GladminApi api) {
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
                    var result = await api.confirmUpdate(hangers[i]);
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

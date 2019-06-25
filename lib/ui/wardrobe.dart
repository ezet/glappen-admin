import 'package:flutter/material.dart';
import 'package:garderobeladmin/data/db.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/services/api.dart';
import 'package:provider/provider.dart';

class Wardrobe extends StatefulWidget {
  const Wardrobe({Key key}) : super(key: key);

  @override
  _WardrobeState createState() => _WardrobeState();
}

class _WardrobeState extends State<Wardrobe> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 38, 43, 1),
        elevation: 0,
        title: const Text(
          'Wardrobe Tags',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        actions: <Widget>[
          FlatButton(
            splashColor: Colors.red,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.undo,
                  color: Colors.white,
                  size: 12,
                ),
                Text('Undo')
              ],
            ),
            onPressed: () => {
                  print('object'),
                },
          ),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(34, 38, 43, 1),
        child: StreamProvider<List<CoatHanger>>.value(
            value: db.streamHangers('KREps4urlJ9Ymy6g9VdY'), child: CoatHangerList()),
      ),
    );
  }
}

class CoatHangerList extends StatelessWidget {
  const CoatHangerList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AbstractGladminApi api = Provider.of<AbstractGladminApi>(context);

    var hangers = Provider.of<List<CoatHanger>>(context);
    if (hangers == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemCount: hangers.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
            height: 30,
            color: Colors.transparent,
          ),
      itemBuilder: (context, i) {
        return Container(
          height: 110,
          decoration: BoxDecoration(
            color: Color.fromRGBO(27, 31, 34, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            border: Border.all(
                color: Color.fromRGBO(66, 74, 82, 1), width: 1.0, style: BorderStyle.solid),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 147, 255, .10),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                    color: Color.fromRGBO(17, 21, 24, 1),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                      ),
                      splashColor: Color.fromRGBO(255, 75, 75, 1),
                      onTap: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('deleted'),
                          ),
                        );
                      },
                      child: Container(
                        child: Center(
                          child: Icon(
                            Icons.cancel,
                            color: Color.fromRGBO(255, 75, 75, 1),
                            size: 33,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(66, 74, 82, 1),
                      ),
                      right: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(66, 74, 82, 1),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        hangers[i].id.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        hangers[i].user,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                      onTap: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('deleted row $i'),
                            backgroundColor: Color.fromRGBO(27, 31, 35, 1),
                          ),
                        );
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
      },
    );
  }
}

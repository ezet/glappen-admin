import 'package:flutter/widgets.dart';
import 'package:garderobeladmin/data/db.dart';
import 'package:provider/provider.dart';

abstract class AbstractGladminApi {
  void scan();

  void confirmCheckin();

  void confirmCheckout();
}

class LocalGladminApi extends StatelessWidget implements AbstractGladminApi {
  @override
  Widget build(BuildContext context) {
    final DatabaseService service = Provider.of<DatabaseService>(context);
    // TODO: implement build
    return null;
  }

  void scan() {
    // TODO: implement scan
  }

  void confirmCheckin() {}

  void confirmCheckout() {}
}

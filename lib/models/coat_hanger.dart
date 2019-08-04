import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobel_api/models/hanger.dart';
import 'package:garderobeladmin/models/user.dart';
import 'package:garderobeladmin/models/venue.dart';

class CoatHanger {
  final DocumentReference ref;
  final String docId;
  final String id;
  final DocumentReference user;
  final Timestamp stateUpdated;
  final HangerState state;

  static const jsonId = "id";
  static const jsonUser = 'user';
  static const jsonStateUpdated = 'stateUpdated';
  static const jsonState = 'state';

  CoatHanger({this.ref, this.docId, this.id, this.user, this.stateUpdated, this.state});

  factory CoatHanger.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return CoatHanger(
      ref: doc.reference,
      docId: doc.documentID,
      id: data[jsonId] ?? null,
      user: data[jsonUser] ?? '',
      state: HangerState.values[data[jsonState]],
      stateUpdated: data[jsonStateUpdated] ?? null,
    );
  }

  DocumentReference get section {
    return ref.parent().parent();
  }

  DocumentReference _venueRef() => ref.parent().parent().parent().parent().parent().parent();

  Stream<Venue> getVenue() {
    return Venue.fromReference(_venueRef());
  }

  Stream<User> getUser() => user.snapshots().map((s) => User.fromFirestore(s));
}

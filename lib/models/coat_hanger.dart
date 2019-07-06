import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/user.dart';
import 'package:garderobeladmin/models/venue.dart';

enum HangerState {
  AVAILABLE,
  TAKEN,
  CHECKING_OUT,
  CHECKING_IN,
}

class CoatHanger {
  final DocumentReference ref;
  final String docId;
  final String id;
  final DocumentReference user;
  final Timestamp stateUpdated;
  final HangerState state;

  static const jsonId = "id";

  CoatHanger({this.ref, this.docId, this.id, this.user, this.stateUpdated, this.state});

  factory CoatHanger.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return CoatHanger(
      ref: doc.reference,
      docId: doc.documentID,
      id: data[jsonId] ?? null,
      user: data['user'] ?? '',
      state: HangerState.values[data['state']],
      stateUpdated: data['stateUpdated'] ?? null,
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

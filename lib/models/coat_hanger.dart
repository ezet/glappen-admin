import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/user.dart';

enum HangerState {
  AVAILABLE,
  TAKEN,
  CHECKING_OUT,
  CHECKING_IN,
}

class CoatHanger {
  final String docId;
  final String id;
  final DocumentReference user;
  final Timestamp stateUpdated;
  final HangerState state;
  final DocumentReference ref;

  CoatHanger(this.ref, {this.docId, this.id, this.user, this.stateUpdated, this.state});

  factory CoatHanger.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return CoatHanger(
      doc.reference,
      docId: doc.documentID,
      id: data['id'] ?? null,
      user: data['user'] ?? '',
      state: HangerState.values[data['state']],
      stateUpdated: data['stateUpdated'] ?? null,
    );
  }

  Stream<User> getUser() => user.snapshots().map((s) => User.fromFirestore(s));
}

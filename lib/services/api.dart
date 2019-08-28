import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobel_api/garderobel_client.dart';
import 'package:garderobel_api/models/reservation.dart';
import 'package:garderobeladmin/models/device.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/user.dart';

class GladminService {
  static const pathUsers = 'users';

  GladminService(this._db) : client = GarderobelClient(_db);

  // ignore: unused_field
  final Firestore _db;
  final GarderobelClient client;

  Future confirmCheckIn(Reservation reservation) {
    return client.confirmCheckInLocal(reservation);
  }

  Stream<List<Reservation>> getReservations(Section section) {
    return client.db.reservations
        .where(ReservationRef.jsonSection, isEqualTo: section.ref)
        .snapshots()
        .map((list) => list.documents.map((item) => ReservationRef.fromFirestore(item)).toList());
  }

  Future confirmCheckOut(Reservation reservation) {
    return client.confirmCheckOutLocal(reservation);
  }

  Stream<Device> getDevice(String deviceId) {
    // TODO: handle single error
    var ref = _db.collection('devices').document(deviceId);
    return ref.snapshots().map((snapshot) => Device.fromFirestore(snapshot));
  }

  Stream<User> getUser(String userId) {
    // TODO: handle single error
    var ref = _db.collection('users').document(userId);
    return ref.snapshots().map((snapshot) => User.fromFirestore(snapshot));
  }

//  simulateCheckInScan(Venue venue, Section section, FirebaseUser user) async {
//    final hangers = await section.hangers
//        .where('state', isEqualTo: HangerState.AVAILABLE.index)
//        .limit(1)
//        .getDocuments();
//    DocumentReference hangerRef;
//    if (hangers.documents.isEmpty) {
//      hangerRef = await section.hangers.add({
//        'id': Random().nextInt(9999).toString(),
//        'state': HangerState.UNAVAILABLE.index,
//        'stateUpdated': FieldValue.serverTimestamp(),
//        'user': _db.collection(pathUsers).document(user.uid)
//      });
//    } else {
//      hangerRef = hangers.documents.first.reference;
//      hangerRef.setData({
//        'state': HangerState.UNAVAILABLE.index,
//        'stateUpdated': FieldValue.serverTimestamp(),
//      }, merge: true);
//    }
//
//    final userRef = _db.collection(pathUsers).document(user.uid);
//
//    final hangerName = await hangerRef.get().then((item) => item.data[CoatHanger.jsonId]);
//    final userName = await userRef.get().then((item) => item.data[User.jsonName]);
//
//    await venue.reservations.add({
//      Reservation.jsonSection: section.ref,
//      Reservation.jsonHanger: hangerRef,
//      Reservation.jsonHangerName: hangerName,
//      Reservation.jsonUser: userRef,
//      Reservation.jsonUserName: userName,
//      Reservation.jsonState: ReservationState.CHECKING_IN.index,
//      Reservation.jsonReservationTime: FieldValue.serverTimestamp(),
//    });
//  }
//
//  simulateCheckOutScan(Venue venue, Section section, FirebaseUser user) async {
//    final reservations = await venue.reservations
//        .where(Reservation.jsonSection, isEqualTo: section.ref)
//        .where(Reservation.jsonState, isEqualTo: ReservationState.CHECKED_IN.index)
//        .where(Reservation.jsonUser, isEqualTo: _db.collection(pathUsers).document(user.uid))
//        .getDocuments();
//    if (reservations.documents.isEmpty) {
//      return Future(() => false);
//    }
//    await reservations.documents.first.reference.updateData({
//      Reservation.jsonStateUpdated: FieldValue.serverTimestamp(),
//      Reservation.jsonState: ReservationState.CHECKING_OUT.index
//    });
//  }

  void updateUser(User user) async {
    return _db.collection(pathUsers).document(user.docId).setData(toFirebase(user), merge: true);
  }

  Map<String, dynamic> toFirebase(User user) {
    return {
      User.jsonPhotoUrl: user.photoUrl,
      User.jsonPhone: user.phone,
      User.jsonName: user.name,
      User.jsonEmail: user.email
    };
  }

  getReservation(String reservationId) {
    // TODO: implement getReservation
    return null;
  }
}

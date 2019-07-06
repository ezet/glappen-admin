import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/user.dart';

class Reservation {
  final DocumentReference ref;
  final String docId;
  final String hangerName;
  final String userName;
  final Timestamp checkIn;
  final Timestamp checkOut;
  final Timestamp reservationTime;
  final HangerState state;
  final DocumentReference hanger;
  final DocumentReference section;
  final DocumentReference user;
  final DocumentReference payment;

  static const jsonReservationTime = 'reservationTime';
  static const jsonCheckIn = 'checkedIn';
  static const jsonCheckOut = 'checkedOut';
  static const jsonHanger = 'hanger';
  static const jsonHangerName = 'hangerName';
  static const jsonSection = 'section';
  static const jsonUser = 'user';
  static const jsonUserName = 'userName';
  static const jsonPayment = 'payment';
  static const jsonState = 'state';

  Reservation(
      {this.ref,
      this.docId,
      this.checkIn,
      this.checkOut,
      this.reservationTime,
      this.hanger,
      this.hangerName,
      this.section,
      this.userName,
      this.user,
      this.state,
      this.payment});

  factory Reservation.fromFirestore(DocumentSnapshot ds) {
    final data = ds.data;
    return Reservation(
        docId: ds.documentID,
        checkIn: data[jsonCheckIn],
        checkOut: data[jsonCheckOut],
        state: HangerState.values[data[jsonState] ?? 1],
        reservationTime: data[jsonReservationTime],
        hanger: data[jsonHanger],
        section: data[jsonSection],
        user: data[jsonUser],
        hangerName: data[jsonHangerName],
        payment: data[jsonPayment]);
  }

  static Map<String, dynamic> getCheckInData(CoatHanger hanger) {
    return {
      jsonCheckIn: FieldValue.serverTimestamp(),
      jsonUser: hanger.user,
      jsonSection: hanger.section,
    };
  }

  static Map<String, dynamic> getCheckOutData(CoatHanger hanger) {
    return {
      jsonCheckOut: FieldValue.serverTimestamp(),
    };
  }

  Stream<User> getUser() => user.snapshots().map((s) => User.fromFirestore(s));
}

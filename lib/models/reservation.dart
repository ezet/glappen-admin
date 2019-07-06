import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/user.dart';
import 'package:meta/meta.dart';

enum ReservationState {
  AVAILABLE,
  TAKEN,
  CHECKING_OUT,
  CHECKING_IN,
}

class Reservation {
  final DocumentReference ref;
  final String docId;
  final String hangerName;
  final String userName;
  final Timestamp checkIn;
  final Timestamp checkOut;
  final Timestamp reservationTime;
  final Timestamp stateUpdated;
  final ReservationState state;
  final DocumentReference hanger;
  final DocumentReference section;
  final DocumentReference user;
  final DocumentReference payment;

  static const jsonReservationTime = 'reservationTime';
  static const jsonStateUpdated = 'stateUpdated';
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
      {@required this.ref,
      @required this.docId,
      @required this.checkIn,
      @required this.checkOut,
      @required this.reservationTime,
      @required this.hanger,
      @required this.hangerName,
      @required this.section,
      @required this.userName,
      @required this.user,
      @required this.state,
      @required this.stateUpdated,
      @required this.payment});

  factory Reservation.fromFirestore(DocumentSnapshot ds) {
    final data = ds.data;
    return Reservation(
        ref: ds.reference,
        docId: ds.documentID,
        checkIn: data[jsonCheckIn],
        checkOut: data[jsonCheckOut],
        stateUpdated: data[jsonStateUpdated],
        state: ReservationState.values[data[jsonState] ?? 1],
        reservationTime: data[jsonReservationTime],
        hanger: data[jsonHanger],
        section: data[jsonSection],
        user: data[jsonUser],
        userName: data[jsonUserName],
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

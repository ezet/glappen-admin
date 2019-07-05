import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';

class Reservation {
  final DocumentReference ref;
  final String docId;
  final Timestamp checkIn;
  final Timestamp checkOut;
  final DocumentReference hanger;
  final DocumentReference section;
  final DocumentReference user;
  final DocumentReference payment;

  static const jsonCheckIn = 'checkedIn';
  static const jsonCheckOut = 'checkedOut';
  static const jsonHanger = 'hanger';
  static const jsonSection = 'section';
  static const jsonUser = 'user';
  static const jsonPayment = 'payment';

  Reservation(
      {this.ref,
      this.docId,
      this.checkIn,
      this.checkOut,
      this.hanger,
      this.section,
      this.user,
      this.payment});

  factory Reservation.fromFirestore(DocumentSnapshot ds) {
    final data = ds.data;
    return Reservation(
        docId: ds.documentID,
        checkIn: data[jsonCheckIn],
        checkOut: data[jsonCheckOut],
        hanger: data[jsonHanger],
        section: data[jsonSection],
        user: data[jsonUser],
        payment: data[jsonPayment]);
  }

  static Map getCheckInData(CoatHanger hanger) {
    return {
      jsonCheckIn: FieldValue.serverTimestamp(),
      jsonUser: hanger.user,
      jsonSection: hanger.section,
    };
  }
}

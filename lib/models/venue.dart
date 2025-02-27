import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobel_api/models/hanger.dart';
import 'package:garderobel_api/models/reservation.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/wardrobe.dart';

class Venue {
  final String id;
  final String name;
  final String email;
  final String city;
  final String logo;
  final String url;
  final CollectionReference wardrobes;
  final CollectionReference reservations;
  final DocumentReference ref;

  Venue(
      {this.ref,
      this.id,
      this.name,
      this.email,
      this.city,
      this.logo,
      this.url,
      this.wardrobes,
      this.reservations});

  static const jsonName = 'name';
  static const jsonEmail = 'email';
  static const jsonCity = 'city';
  static const jsonUrl = 'url';
  static const jsonLogo = 'logo';
  static const jsonWardrobes = 'wardrobes';
  static const jsonReservations = 'reservations';

  factory Venue.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Venue(
        ref: doc.reference,
        id: doc.documentID,
        name: data[jsonName] ?? '',
        email: data[jsonEmail] ?? '',
        city: data[jsonCity] ?? '',
        logo: data[jsonLogo] ?? '',
        url: data[jsonUrl] ?? '',
        wardrobes: doc.reference.collection(jsonWardrobes),
        reservations: doc.reference.collection(jsonReservations));
  }

  static Stream<Venue> fromReference(DocumentReference ref) {
    return ref.snapshots().map((venue) => Venue.fromFirestore(venue));
  }

  toFirestore() {
    return {
      jsonName: name,
      jsonUrl: url,
      jsonLogo: logo,
      jsonCity: city,
      jsonEmail: email,
    };
  }

  Stream<List<Wardrobe>> getWardrobes() {
    return wardrobes
        .snapshots()
        .map((list) => list.documents.map((item) => Wardrobe.fromFirestore(item)).toList());
  }

  Stream<List<Reservation>> getReservations() {
    return reservations
        .snapshots()
        .map((list) => list.documents.map((item) => ReservationRef.fromFirestore(item)).toList());
  }

  Future<DocumentReference> addWardrobe(Wardrobe wardrobe) async {
    return wardrobes.add(wardrobe.toFirestore());
  }

  Future<bool> updateDetails(Venue venue) async {
    return ref.updateData(venue.toFirestore()).then((value) => true, onError: (error) => false);
  }

  Future<void> handleRejection(Reservation reservation) async {
    if (reservation.state == ReservationState.CHECKING_IN) {
      await reservation.ref.updateData({
        ReservationRef.jsonStateUpdated: FieldValue.serverTimestamp(),
        ReservationRef.jsonState: ReservationState.CHECK_IN_REJECTED.index,
      });
      return reservation.hanger.updateData({
        CoatHanger.jsonState: HangerState.AVAILABLE.index,
        CoatHanger.jsonStateUpdated: FieldValue.serverTimestamp()
      });
    } else {
      return reservation.ref.updateData({
        ReservationRef.jsonStateUpdated: FieldValue.serverTimestamp(),
        ReservationRef.jsonState: ReservationState.CHECKED_IN.index,
      });
    }
  }

//  Future<void> _confirmCheckIn(Reservation reservation) async {
//    return reservation.ref.updateData({
//      Reservation.jsonCheckIn: FieldValue.serverTimestamp(),
//      Reservation.jsonStateUpdated: FieldValue.serverTimestamp(),
//      Reservation.jsonState: ReservationState.CHECKED_IN.index,
//    });
//  }
//
//  Future<void> _confirmCheckOut(Reservation reservation) async {
//    await reservation.ref.updateData({
//      Reservation.jsonCheckOut: FieldValue.serverTimestamp(),
//      Reservation.jsonStateUpdated: FieldValue.serverTimestamp(),
//      Reservation.jsonState: ReservationState.CHECKED_OUT.index,
//    });
//
//    return reservation.hanger.updateData({
//      CoatHanger.jsonStateUpdated: FieldValue.serverTimestamp(),
//      CoatHanger.jsonState: HangerState.AVAILABLE.index,
//    }).then((value) => true, onError: (error) {
//      print(error);
//      return false;
//    });
}

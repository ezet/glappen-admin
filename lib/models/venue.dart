import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/coat_hanger.dart';
import 'package:garderobeladmin/models/reservation.dart';
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
        .map((list) => list.documents.map((item) => Reservation.fromFirestore(item)).toList());
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
        Reservation.jsonStateUpdated: FieldValue.serverTimestamp(),
        Reservation.jsonState: ReservationState.CHECK_IN_REJECTED.index,
      });
      return reservation.hanger.updateData({
        CoatHanger.jsonState: HangerState.AVAILABLE.index,
        CoatHanger.jsonStateUpdated: FieldValue.serverTimestamp()
      });
    } else {
      return reservation.ref.updateData({
        Reservation.jsonStateUpdated: FieldValue.serverTimestamp(),
        Reservation.jsonState: ReservationState.CHECKED_IN.index,
      });
    }
  }

  Future<void> handleConfirmation(Reservation reservation) async {
    if (reservation.state == ReservationState.CHECKING_IN) {
      return _confirmCheckIn(reservation);
    } else if (reservation.state == ReservationState.CHECKING_OUT) {
      return _confirmCheckOut(reservation);
    } else {
      throw "Invalid reservation state: ${reservation.state}";
    }
  }

  Future<void> _confirmCheckIn(Reservation reservation) async {
    return reservation.ref.updateData({
      Reservation.jsonCheckIn: FieldValue.serverTimestamp(),
      Reservation.jsonStateUpdated: FieldValue.serverTimestamp(),
      Reservation.jsonState: ReservationState.CHECKED_IN.index,
    });
//    return reservation.ref.setData({
//      'stateUpdated': FieldValue.serverTimestamp(),
//      'state': HangerState.UNAVAILABLE.index,
//      'reservation': reservation
//    }, merge: true).then((value) => true, onError: (error) {
//      print(error);
//      return false;
//    });
  }

  Future<void> _confirmCheckOut(Reservation reservation) async {
    await reservation.ref.updateData({
      Reservation.jsonCheckOut: FieldValue.serverTimestamp(),
      Reservation.jsonStateUpdated: FieldValue.serverTimestamp(),
      Reservation.jsonState: ReservationState.CHECKED_IN.index,
    });

    return reservation.hanger.updateData({
      CoatHanger.jsonStateUpdated: FieldValue.serverTimestamp(),
      CoatHanger.jsonState: HangerState.AVAILABLE.index,
    }).then((value) => true, onError: (error) {
      print(error);
      return false;
    });
  }
}

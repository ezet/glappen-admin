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

  Future<bool> handleConfirmation(Reservation reservation) async {
//    if (reservation.state == HangerState.CHECKING_IN) {
//      return _confirmCheckIn(hanger);
//    } else {
//      hanger.reservation.updateData(Reservation.getCheckOutData(hanger));
//      return _confirmCheckOut(hanger);
//    }
  }

  Future<bool> _confirmCheckIn(CoatHanger hanger) async {
//    await hanger.reservation.updateData({Reservation.jsonCheckIn: FieldValue.serverTimestamp()});
//    return hanger.ref.setData({
//      'stateUpdated': FieldValue.serverTimestamp(),
//      'state': HangerState.TAKEN.index,
//      'reservation': reservation
//    }, merge: true).then((value) => true, onError: (error) {
//      print(error);
//      return false;
//    });
  }

  Future<bool> _confirmCheckOut(CoatHanger hanger) async {
    return hanger.ref.setData({
      'stateUpdated': FieldValue.serverTimestamp(),
      'state': HangerState.AVAILABLE.index,
      'reservation': null,
      'user': null
    }, merge: true).then((value) => true, onError: (error) {
      print(error);
      return false;
    });
  }
}

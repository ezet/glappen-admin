import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/venue.dart';

class Device {
  final String docId;
  final DocumentReference section;
  final DocumentReference venue;

  Device.fromFirestore(DocumentSnapshot doc)
      : docId = doc.documentID,
        section = doc.data['section'],
        venue = doc.data['section'].parent().parent().parent().parent();

  Stream<Section> getSection() {
    return section.snapshots().map((section) => Section.fromFirestore(section));
  }

  Stream<Venue> getVenue() {
    return venue.snapshots().map((venue) => Venue.fromFirestore(venue));
  }
}

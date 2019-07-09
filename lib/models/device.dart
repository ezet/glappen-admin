import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garderobeladmin/models/section.dart';
import 'package:garderobeladmin/models/venue.dart';

class Device {
  final String docId;
  final DocumentReference section;
  final DocumentReference venue;

  const Device({this.docId, this.section, this.venue});

  factory Device.fromFirestore(DocumentSnapshot doc) {
    final docId = doc.documentID;
    final data = doc.data ?? {};
    final section = data['section'] ?? null;
    final venue = data['section']?.parent()?.parent()?.parent()?.parent() ?? null;
    return Device(docId: docId, section: section, venue: venue);
  }

  Stream<Section> getSection() {
    return section.snapshots().map((section) => Section.fromFirestore(section));
  }

  Stream<Venue> getVenue() {
    return Venue.fromReference(venue);
  }
}

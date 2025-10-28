import 'package:cloud_firestore/cloud_firestore.dart';

class AMCLCLSAppointment {
  final String? id;
  final String uid;
  final String doctorName;
  final String specialty;
  final DateTime appointmentDateTime;
  final String location;
  final String notes;

  AMCLCLSAppointment({
    this.id,
    required this.uid,
    required this.doctorName,
    required this.specialty,
    required this.appointmentDateTime,
    required this.location,
    this.notes = '',
  });

  factory AMCLCLSAppointment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AMCLCLSAppointment(
      id: doc.id,
      uid: data['uid'],
      doctorName: data['doctorName'],
      specialty: data['specialty'],
      appointmentDateTime: (data['appointmentDateTime'] as Timestamp).toDate(),
      location: data['location'],
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'doctorName': doctorName,
      'specialty': specialty,
      'appointmentDateTime': Timestamp.fromDate(appointmentDateTime),
      'location': location,
      'notes': notes,
    };
  }
}
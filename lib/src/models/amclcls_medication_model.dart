import 'package:cloud_firestore/cloud_firestore.dart';

class AMCLCLSMedication {
  final String? id;
  final String uid;
  final String name;
  final String dosage;
  final String frequency;
  final String notes;

  AMCLCLSMedication({
    this.id,
    required this.uid,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.notes = '',
  });

  factory AMCLCLSMedication.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AMCLCLSMedication(
      id: doc.id,
      uid: data['uid'],
      name: data['name'],
      dosage: data['dosage'],
      frequency: data['frequency'],
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'notes': notes,
    };
  }
}
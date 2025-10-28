import 'package:cloud_firestore/cloud_firestore.dart';

class AMCLCLSSymptom {
  final String? id;
  final String uid;
  final String name;
  final int intensity;
  final DateTime timestamp;
  final String notes;

  AMCLCLSSymptom({
    this.id,
    required this.uid,
    required this.name,
    required this.intensity,
    required this.timestamp,
    this.notes = '',
  });

  factory AMCLCLSSymptom.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AMCLCLSSymptom(
      id: doc.id,
      uid: data['uid'],
      name: data['name'],
      intensity: data['intensity'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'intensity': intensity,
      'timestamp': Timestamp.fromDate(timestamp),
      'notes': notes,
    };
  }
}
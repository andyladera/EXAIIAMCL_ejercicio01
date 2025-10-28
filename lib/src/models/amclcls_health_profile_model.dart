import 'package:cloud_firestore/cloud_firestore.dart';

class AMCLCLSHealthProfile {
  final String uid;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<Map<String, String>> currentMedications;
  final List<Map<String, String>> emergencyContacts;

  AMCLCLSHealthProfile({
    required this.uid,
    List<String>? allergies,
    List<String>? chronicConditions,
    List<Map<String, String>>? currentMedications,
    List<Map<String, String>>? emergencyContacts,
  })  : allergies = allergies ?? [],
        chronicConditions = chronicConditions ?? [],
        currentMedications = currentMedications ?? [],
        emergencyContacts = emergencyContacts ?? [];

  factory AMCLCLSHealthProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AMCLCLSHealthProfile(
      uid: doc.id,
      allergies: List<String>.from(data['allergies'] ?? []),
      chronicConditions: List<String>.from(data['chronicConditions'] ?? []),
      currentMedications: (data['currentMedications'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [],
      emergencyContacts: (data['emergencyContacts'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'currentMedications': currentMedications,
      'emergencyContacts': emergencyContacts,
    };
  }
}
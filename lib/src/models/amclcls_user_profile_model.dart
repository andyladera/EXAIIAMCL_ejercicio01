import 'package:cloud_firestore/cloud_firestore.dart';

class AMCLCLSUserProfile {
  final String uid;
  final String name;
  final DateTime birthDate;
  final String gender;
  final double height;
  final double weight;
  final String bloodType;

  AMCLCLSUserProfile({
    required this.uid,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.bloodType,
  });

  factory AMCLCLSUserProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AMCLCLSUserProfile(
      uid: doc.id,
      name: data['name'] ?? '',
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      gender: data['gender'] ?? '',
      height: (data['height'] ?? 0.0).toDouble(),
      weight: (data['weight'] ?? 0.0).toDouble(),
      bloodType: data['bloodType'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'birthDate': Timestamp.fromDate(birthDate),
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
    };
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/amclcls_health_profile_model.dart';

class AMCLCLSHealthProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'healthProfiles';

  Future<void> createHealthProfile(AMCLCLSHealthProfile healthProfile) {
    return _firestore
        .collection(_collectionPath)
        .doc(healthProfile.uid)
        .set(healthProfile.toFirestore());
  }

  Future<AMCLCLSHealthProfile?> getHealthProfile(String uid) async {
    DocumentSnapshot doc = await _firestore.collection(_collectionPath).doc(uid).get();
    if (doc.exists) {
      return AMCLCLSHealthProfile.fromFirestore(doc);
    }
    return null;
  }

  Future<void> updateHealthProfile(AMCLCLSHealthProfile healthProfile) {
    return _firestore
        .collection(_collectionPath)
        .doc(healthProfile.uid)
        .set(healthProfile.toFirestore(), SetOptions(merge: true));
  }
}
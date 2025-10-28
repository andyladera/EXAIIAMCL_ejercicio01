import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/amclcls_user_profile_model.dart';

class AMCLCLSUserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'userProfiles';

  Future<void> createUserProfile(AMCLCLSUserProfile userProfile) {
    return _firestore
        .collection(_collectionPath)
        .doc(userProfile.uid)
        .set(userProfile.toFirestore());
  }

  Future<AMCLCLSUserProfile?> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _firestore.collection(_collectionPath).doc(uid).get();
    if (doc.exists) {
      return AMCLCLSUserProfile.fromFirestore(doc);
    }
    return null;
  }

  Future<void> updateUserProfile(AMCLCLSUserProfile userProfile) {
    return _firestore
        .collection(_collectionPath)
        .doc(userProfile.uid)
        .set(userProfile.toFirestore(), SetOptions(merge: true));
  }
}
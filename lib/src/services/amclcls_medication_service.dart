import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/amclcls_medication_model.dart';

class AMCLCLSMedicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'medications';

  Future<void> addMedication(AMCLCLSMedication medication) {
    return _firestore.collection(_collectionPath).add(medication.toFirestore());
  }

  Stream<List<AMCLCLSMedication>> getMedications(String uid) {
    return _firestore
        .collection(_collectionPath)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AMCLCLSMedication.fromFirestore(doc))
            .toList());
  }

  Future<void> deleteMedication(String id) {
    return _firestore.collection(_collectionPath).doc(id).delete();
  }
}
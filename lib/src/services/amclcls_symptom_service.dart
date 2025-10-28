import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/amclcls_symptom_model.dart';

class AMCLCLSSymptomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'symptoms';

  Future<void> addSymptom(AMCLCLSSymptom symptom) {
    return _firestore.collection(_collectionPath).add(symptom.toFirestore());
  }

  Stream<List<AMCLCLSSymptom>> getSymptoms(String uid) {
    return _firestore
        .collection(_collectionPath)
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AMCLCLSSymptom.fromFirestore(doc))
            .toList());
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/amclcls_appointment_model.dart';

class AMCLCLSAppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addAppointment(AMCLCLSAppointment appointment) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('appointments').add(appointment.toFirestore());
    }
  }

  Stream<List<AMCLCLSAppointment>> getAppointments() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('appointments')
          .where('uid', isEqualTo: user.uid)
          .orderBy('appointmentDateTime', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AMCLCLSAppointment.fromFirestore(doc))
              .toList());
    } else {
      return Stream.value([]);
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).delete();
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import '../models/amclcls_user_profile_model.dart';
import '../services/amclcls_user_profile_service.dart';

class AMCLCLSAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AMCLCLSUserProfileService _userProfileService = AMCLCLSUserProfileService();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signUp({required String email, required String password}) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AMCLCLSUserProfile newUserProfile = AMCLCLSUserProfile(
        uid: credential.user!.uid,
        name: '',
        birthDate: DateTime.now(),
        gender: '',
        height: 0.0,
        weight: 0.0,
        bloodType: '',
      );

      await _userProfileService.createUserProfile(newUserProfile);

      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unknown error occurred";
    }
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
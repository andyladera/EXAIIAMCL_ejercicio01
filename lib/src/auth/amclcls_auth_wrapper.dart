import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:exaiiamcl/src/auth/amclcls_auth_service.dart';
import 'package:exaiiamcl/src/auth/screens/amclcls_login_screen.dart';
import 'package:exaiiamcl/src/home/amclcls_home_screen.dart';

class AMCLCLSAuthWrapper extends StatelessWidget {
  final AMCLCLSAuthService _authService = AMCLCLSAuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return AMCLCLSLoginScreen();
          } 
          return AMCLCLSHomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
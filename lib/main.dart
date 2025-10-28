import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:exaiiamcl/src/auth/amclcls_auth_wrapper.dart';
import 'package:exaiiamcl/src/theme/amclcls_app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AMCLCLSAppTheme.lightTheme,
      home: AMCLCLSAuthWrapper(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:exaiiamcl/src/auth/amclcls_auth_service.dart';
import 'package:exaiiamcl/src/profile/screens/amclcls_user_profile_screen.dart';
import 'package:exaiiamcl/src/profile/screens/amclcls_health_profile_screen.dart';
import '../symptom_tracking/amclcls_symptom_tracking_screen.dart';
import '../medication_management/amclcls_medication_management_screen.dart';
import '../medical_agenda/amclcls_medical_agenda_screen.dart';

class AMCLCLSHomeScreen extends StatelessWidget {
  final AMCLCLSAuthService _authService = AMCLCLSAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Principal'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AMCLCLSUserProfileScreen()),
                );
              },
              child: const Text('Ver Perfil'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AMCLCLSHealthProfileScreen()),
                );
              },
              child: const Text('Ver Perfil de Salud'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AMCLCLSSymptomTrackingScreen()),
                );
              },
              child: const Text('Seguimiento de Síntomas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AMCLCLSMedicationManagementScreen()),
                );
              },
              child: const Text('Gestión de Medicamentos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AMCLCLSMedicalAgendaScreen()),
                );
              },
              child: const Text('Agenda Médica'),
            ),
          ],
        ),
      ),
    );
  }
}
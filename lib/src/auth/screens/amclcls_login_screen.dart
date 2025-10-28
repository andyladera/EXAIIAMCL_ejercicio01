import 'package:flutter/material.dart';
import 'package:exaiiamcl/src/auth/amclcls_auth_service.dart';
import 'package:exaiiamcl/src/auth/screens/amclcls_signup_screen.dart';

class AMCLCLSLoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AMCLCLSAuthService _authService = AMCLCLSAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String? result = await _authService.signIn(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                if (result == "Signed in") {
                  // Navegar a la pantalla principal
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result ?? 'Error desconocido')),
                  );
                }
              },
              child: Text('Iniciar Sesión'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AMCLCLSSignUpScreen()),
                );
              },
              child: Text('¿No tienes una cuenta? Regístrate'),
            )
          ],
        ),
      ),
    );
  }
}
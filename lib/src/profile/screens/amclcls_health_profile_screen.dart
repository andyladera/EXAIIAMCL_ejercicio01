import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/amclcls_health_profile_model.dart';
import '../../services/amclcls_health_profile_service.dart';

class AMCLCLSHealthProfileScreen extends StatefulWidget {
  const AMCLCLSHealthProfileScreen({super.key});

  @override
  _AMCLCLSHealthProfileScreenState createState() => _AMCLCLSHealthProfileScreenState();
}

class _AMCLCLSHealthProfileScreenState extends State<AMCLCLSHealthProfileScreen> {
  final AMCLCLSHealthProfileService _healthProfileService = AMCLCLSHealthProfileService();
  final _formKey = GlobalKey<FormState>();
  late String _uid;
  late AMCLCLSHealthProfile _healthProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _loadHealthProfile();
  }

  Future<void> _loadHealthProfile() async {
    AMCLCLSHealthProfile? healthProfile = await _healthProfileService.getHealthProfile(_uid);
    setState(() {
      _healthProfile = healthProfile ?? AMCLCLSHealthProfile(uid: _uid);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Salud'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Alergias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildEditableList(_healthProfile.allergies, 'Alergia'),
                    const SizedBox(height: 20),
                    const Text('Condiciones Crónicas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildEditableList(_healthProfile.chronicConditions, 'Condición'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await _healthProfileService.updateHealthProfile(_healthProfile);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Perfil de salud actualizado con éxito')),
                          );
                        }
                      },
                      child: const Text('Guardar Cambios'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEditableList(List<String> items, String hint) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) {
          return IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                items.add('');
              });
            },
          );
        }
        return TextFormField(
          initialValue: items[index],
          decoration: InputDecoration(labelText: hint),
          onChanged: (value) {
            items[index] = value;
          },
        );
      },
    );
  }
}
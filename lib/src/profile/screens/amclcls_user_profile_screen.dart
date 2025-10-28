import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/amclcls_user_profile_model.dart';
import '../../services/amclcls_user_profile_service.dart';

class AMCLCLSUserProfileScreen extends StatefulWidget {
  const AMCLCLSUserProfileScreen({super.key});

  @override
  _AMCLCLSUserProfileScreenState createState() => _AMCLCLSUserProfileScreenState();
}

class _AMCLCLSUserProfileScreenState extends State<AMCLCLSUserProfileScreen> {
  final AMCLCLSUserProfileService _userProfileService = AMCLCLSUserProfileService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _bloodTypeController;
  late String _uid;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _nameController = TextEditingController();
    _birthDateController = TextEditingController();
    _genderController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _bloodTypeController = TextEditingController();
    _selectedDate = DateTime.now();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    AMCLCLSUserProfile? userProfile = await _userProfileService.getUserProfile(_uid);
    if (userProfile != null) {
      setState(() {
        _nameController.text = userProfile.name;
        _selectedDate = userProfile.birthDate;
        _birthDateController.text = _selectedDate.toIso8601String().split('T').first;
        _genderController.text = userProfile.gender;
        _heightController.text = userProfile.height.toString();
        _weightController.text = userProfile.weight.toString();
        _bloodTypeController.text = userProfile.bloodType;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = _selectedDate.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Nacimiento',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_birthDateController.text.isEmpty
                          ? 'Seleccione una fecha'
                          : _birthDateController.text),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Género'),
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _bloodTypeController,
                decoration: const InputDecoration(labelText: 'Tipo de Sangre'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    AMCLCLSUserProfile updatedProfile = AMCLCLSUserProfile(
                      uid: _uid,
                      name: _nameController.text,
                      birthDate: _selectedDate,
                      gender: _genderController.text,
                      height: double.tryParse(_heightController.text) ?? 0.0,
                      weight: double.tryParse(_weightController.text) ?? 0.0,
                      bloodType: _bloodTypeController.text,
                    );
                    await _userProfileService.updateUserProfile(updatedProfile);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil actualizado con éxito')),
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
}
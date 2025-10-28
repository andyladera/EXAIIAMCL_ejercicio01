import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/amclcls_symptom_model.dart';
import '../services/amclcls_symptom_service.dart';

class AMCLCLSSymptomTrackingScreen extends StatefulWidget {
  @override
  _AMCLCLSSymptomTrackingScreenState createState() =>
      _AMCLCLSSymptomTrackingScreenState();
}

class _AMCLCLSSymptomTrackingScreenState
    extends State<AMCLCLSSymptomTrackingScreen> {
  final AMCLCLSSymptomService _symptomService = AMCLCLSSymptomService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  double _intensity = 1.0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Seguimiento de Síntomas')),
        body: Center(child: Text('Por favor, inicie sesión para continuar.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento de Síntomas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Síntoma'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese el nombre del síntoma';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Intensidad: ${_intensity.toInt()}'),
                  Slider(
                    value: _intensity,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _intensity.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _intensity = value;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(labelText: 'Notas (opcional)'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newSymptom = AMCLCLSSymptom(
                          uid: user.uid,
                          name: _nameController.text,
                          intensity: _intensity.toInt(),
                          timestamp: DateTime.now(),
                          notes: _notesController.text,
                        );
                        _symptomService.addSymptom(newSymptom).then((_) {
                          _nameController.clear();
                          _notesController.clear();
                          setState(() {
                            _intensity = 1.0;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Síntoma guardado')),
                          );
                        });
                      }
                    },
                    child: Text('Guardar Síntoma'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AMCLCLSSymptom>>(
              stream: _symptomService.getSymptoms(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay síntomas registrados.'));
                }
                final symptoms = snapshot.data!;
                return ListView.builder(
                  itemCount: symptoms.length,
                  itemBuilder: (context, index) {
                    final symptom = symptoms[index];
                    return ListTile(
                      title: Text(symptom.name),
                      subtitle: Text(
                          'Intensidad: ${symptom.intensity} - ${symptom.timestamp.toLocal()}'),
                      trailing: Text(symptom.notes),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/amclcls_medication_model.dart';
import '../services/amclcls_medication_service.dart';

class AMCLCLSMedicationManagementScreen extends StatefulWidget {
  @override
  _AMCLCLSMedicationManagementScreenState createState() =>
      _AMCLCLSMedicationManagementScreenState();
}

class _AMCLCLSMedicationManagementScreenState
    extends State<AMCLCLSMedicationManagementScreen> {
  final AMCLCLSMedicationService _medicationService = AMCLCLSMedicationService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Gestión de Medicamentos')),
        body: Center(child: Text('Por favor, inicie sesión para continuar.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Medicamentos'),
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
                    decoration: InputDecoration(labelText: 'Medicamento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese el nombre del medicamento';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dosageController,
                    decoration: InputDecoration(labelText: 'Dosis'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la dosis';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _frequencyController,
                    decoration: InputDecoration(labelText: 'Frecuencia'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la frecuencia';
                      }
                      return null;
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
                        final newMedication = AMCLCLSMedication(
                          uid: user.uid,
                          name: _nameController.text,
                          dosage: _dosageController.text,
                          frequency: _frequencyController.text,
                          notes: _notesController.text,
                        );
                        _medicationService.addMedication(newMedication).then((_) {
                          _nameController.clear();
                          _dosageController.clear();
                          _frequencyController.clear();
                          _notesController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Medicamento guardado')),
                          );
                        });
                      }
                    },
                    child: Text('Guardar Medicamento'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AMCLCLSMedication>>(
              stream: _medicationService.getMedications(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay medicamentos registrados.'));
                }
                final medications = snapshot.data!;
                return ListView.builder(
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final medication = medications[index];
                    return ListTile(
                      title: Text(medication.name),
                      subtitle: Text('${medication.dosage} - ${medication.frequency}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _medicationService.deleteMedication(medication.id!);
                        },
                      ),
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
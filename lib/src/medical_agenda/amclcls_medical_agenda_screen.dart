import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/amclcls_appointment_model.dart';
import '../services/amclcls_appointment_service.dart';

class AMCLCLSMedicalAgendaScreen extends StatefulWidget {
  const AMCLCLSMedicalAgendaScreen({super.key});

  @override
  _AMCLCLSMedicalAgendaScreenState createState() =>
      _AMCLCLSMedicalAgendaScreenState();
}

class _AMCLCLSMedicalAgendaScreenState
    extends State<AMCLCLSMedicalAgendaScreen> {
  final AMCLCLSAppointmentService _appointmentService =
      AMCLCLSAppointmentService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _doctorNameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addAppointment() {
    if (_formKey.currentState!.validate()) {
      final User? user = _auth.currentUser;
      if (user != null) {
        final newAppointment = AMCLCLSAppointment(
          uid: user.uid,
          doctorName: _doctorNameController.text,
          specialty: _specialtyController.text,
          appointmentDateTime: DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _selectedTime.hour,
            _selectedTime.minute,
          ),
          location: _locationController.text,
          notes: _notesController.text,
        );

        _appointmentService.addAppointment(newAppointment).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cita guardada con éxito')),
          );
          _formKey.currentState!.reset();
          _doctorNameController.clear();
          _specialtyController.clear();
          _locationController.clear();
          _notesController.clear();
          setState(() {
            _selectedDate = DateTime.now();
            _selectedTime = TimeOfDay.now();
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar la cita: $error')),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Médica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _doctorNameController,
                    decoration: const InputDecoration(labelText: 'Médico'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese el nombre del médico';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _specialtyController,
                    decoration: const InputDecoration(labelText: 'Especialidad'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la especialidad';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Ubicación'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la ubicación';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(labelText: 'Notas (opcional)'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            "Fecha: ${DateFormat.yMd().format(_selectedDate)}"),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Seleccionar Fecha'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Hora: ${_selectedTime.format(context)}"),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: const Text('Seleccionar Hora'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addAppointment,
                    child: const Text('Guardar Cita'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Próximas Citas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<List<AMCLCLSAppointment>>(
                stream: _appointmentService.getAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error al cargar las citas: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No hay citas registradas.'));
                  }

                  final appointments = snapshot.data!;

                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                              '${appointment.doctorName} - ${appointment.specialty}'),
                          subtitle: Text(
                              '${DateFormat.yMd().add_jm().format(appointment.appointmentDateTime)}\n${appointment.location}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _appointmentService
                                  .deleteAppointment(appointment.id!)
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Cita eliminada')),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error al eliminar la cita: $error')),
                                );
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
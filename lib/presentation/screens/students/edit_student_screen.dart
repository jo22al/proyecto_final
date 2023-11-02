import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/database_helper.dart';
import '../../../models/student_model.dart';
import '../../widgets/widgets.dart';

class EditStudentScreen extends StatefulWidget {
  static const String routeName = '/edit-student';

  final Student student;

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.student.name;
    _lastNameController.text = widget.student.lastname;
    _dateOfBirthController.text = widget.student.dateOfBirth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar estudiante'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _mostrarAdvertencia(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomInput(
                    icon: Icons.person,
                    labelText: const Text('Nombre'),
                    placeHolder: 'Nombre',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  CustomInput(
                    icon: Icons.person,
                    labelText: const Text('Apellido'),
                    placeHolder: 'Apellido',
                    controller: _lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un apellido';
                      }
                      return null;
                    },
                  ),
                  CustomInput(
                    icon: Icons.calendar_today,
                    labelText: const Text('Fecha de nacimiento'),
                    placeHolder: 'Fecha de nacimiento',
                    controller: _dateOfBirthController,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        _dateOfBirthController.text =
                            '${date.day}/${date.month}/${date.year}';
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una fecha de nacimiento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => _handleUpdateStudent(context),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Actualizar Estudiante'),
                  ),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _handleUpdateStudent(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String name = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String dateOfBirth = _dateOfBirthController.text.trim();

    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'id': widget.student.id,
        'name': name,
        'lastname': lastName,
        'dateOfBirth': dateOfBirth,
      };

      int id = await _databaseHelper.update(row, 'students');
      debugPrint('updated row id: $id');

      if (!context.mounted) return;
      _nameController.clear();
      _lastNameController.clear();
      _dateOfBirthController.clear();
      context.pop();
    } else {
      if (!context.mounted) return;
      setState(() {
        _errorMessage = 'Error al actualizar estudiante';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _mostrarAdvertencia(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Advertencia'),
          content: const Text('¿Seguro que deseas borrar este registro?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            ElevatedButton(
              child: const Text('Borrar'),
              onPressed: () async {
                Map<String, dynamic> row = {
                  'id': widget.student.id,
                  'status': '0',
                };
                await _databaseHelper.update(row, 'students');
                if (!context.mounted) return;
                context.go('/students');
              },
            ),
          ],
        );
      },
    );
  }
}

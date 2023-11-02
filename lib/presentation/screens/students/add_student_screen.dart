import 'package:flutter/material.dart';
import 'package:memory_project/presentation/widgets/alert/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/database_helper.dart';
import '../../widgets/form_input/custom_form_field.dart';

class AddStudentScreen extends StatefulWidget {
  static const routeName = '/add-student';

  AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;
  String? idTeacher;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idTeacher = prefs.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Estudiante'),
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
                  icon: Icons.numbers_outlined,
                  labelText: const Text('Código'),
                  placeHolder: 'Código',
                  controller: _codigoController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese el código';
                    }
                    return null;
                  },
                ),
                CustomInput(
                  icon: Icons.person,
                  labelText: const Text('Nombre'),
                  placeHolder: 'Nombre',
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese el nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomInput(
                  icon: Icons.person,
                  controller: _lastNameController,
                  placeHolder: 'Apellidos',
                  labelText: const Text('Apellidos'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese los apellidos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomInput(
                  icon: Icons.calendar_today,
                  placeHolder: 'Fecha de nacimiento',
                  labelText: const Text('Fecha de nacimiento'),
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
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese una fecha de nacimiento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed:
                      _isLoading ? null : () => _handleAddStudent(context),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Agregar Estudiante'),
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
      ),
    );
  }

  Future<void> _handleAddStudent(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String codigo = _codigoController.text.trim();
    String name = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String dateOfBirth = _dateOfBirthController.text.trim();

    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'codigo': codigo,
        'name': name,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'teacher_id': idTeacher,
      };
      int id = await _databaseHelper.insert(row, 'students');
      debugPrint('inserted row id: $id');

      if (!context.mounted) return;
      showAlert(context, 'Correcto', 'Estudiante creado exitosamente');
      _codigoController.clear();
      _nameController.clear();
      _lastNameController.clear();
      _dateOfBirthController.clear();
    } else {
      if (!context.mounted) return;
      setState(() {
        _errorMessage = 'Por favor, verifique los datos ingresados';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }
}

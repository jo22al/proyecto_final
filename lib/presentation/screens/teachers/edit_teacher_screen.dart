import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_project/presentation/widgets/form_input/custom_form_field.dart';

import '../../../data/database_helper.dart';
import '../../../models/teacher_model.dart';

class EditTeacherScreen extends StatefulWidget {
  static const routeName = '/teachers/edit';

  final Teacher teacher;

  const EditTeacherScreen({super.key, required this.teacher});

  @override
  State<EditTeacherScreen> createState() => _EditTeacherScreenState();
}

class _EditTeacherScreenState extends State<EditTeacherScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.teacher.name;
    _lastNameController.text = widget.teacher.lastname;
    _emailController.text = widget.teacher.email;
    _passwordController.text = widget.teacher.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar profesor'),
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
                    controller: _nameController,
                    icon: Icons.person_outline,
                    placeHolder: 'Nombre',
                    labelText: const Text('Nombre'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese su nombre';
                      }
                      return null;
                    }),
                CustomInput(
                    controller: _lastNameController,
                    icon: Icons.person_outline,
                    placeHolder: 'Apellido',
                    labelText: const Text('Apellido'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese su apellido';
                      }
                      return null;
                    }),
                CustomInput(
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  placeHolder: 'Correo electrónico',
                  labelText: const Text('Correo electrónico'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),
                CustomInput(
                  controller: _passwordController,
                  icon: Icons.password_outlined,
                  placeHolder: 'Contraseña',
                  labelText: const Text('Contraseña'),
                  isPassword: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed:
                      _isLoading ? null : () => _handleUpdateTeacher(context),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Actualizar profesor'),
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

  Future<void> _handleUpdateTeacher(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'id': widget.teacher.id,
        'name': _nameController.text.trim(),
        'lastname': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      int id = await _databaseHelper.update(row, 'teachers');
      debugPrint('updated row id: $id');

      if (!context.mounted) return;
      _nameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      context.pop();
    } else {
      setState(() {
        _errorMessage = 'Por favor, ingrese todos los campos';
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
                  'id': widget.teacher.id,
                  'status': '0',
                };
                await _databaseHelper.update(row, 'teachers');
                if (!context.mounted) return;
                context.go('/teachers');
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/database_helper.dart';
import '../../../models/teacher_model.dart';
import '../../widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = '/reset_password';
  final Teacher teacher;

  const ResetPasswordScreen({super.key, required this.teacher});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Logo(),
              const SizedBox(height: 20),
              _Form(
                  newPasswordController: newPasswordController,
                  confirmPasswordController: confirmPasswordController,
                  databaseHelper: databaseHelper,
                  teacher: widget.teacher),
              const SizedBox(height: 20),
              const _Labels()
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final DatabaseHelper databaseHelper;
  final Teacher teacher;

  const _Form(
      {required this.newPasswordController,
      required this.confirmPasswordController,
      required this.databaseHelper,
      required this.teacher});

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  bool _isLoading = false;
  String? _errorMessage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomInput(
              icon: Icons.lock_outline,
              controller: widget.newPasswordController,
              placeHolder: 'Nueva Contraseña',
              labelText: const Text('Nueva Contraseña'),
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su nueva contraseña';
                }
                return null;
              },
            ),
            CustomInput(
              icon: Icons.lock_outline,
              controller: widget.confirmPasswordController,
              placeHolder: 'Confirmar Contraseña',
              labelText: const Text('Confirmar Contraseña'),
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor confirme su nueva contraseña';
                }
                if (value != widget.newPasswordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed:
                  _isLoading ? null : () => _handleResetPassword(context),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Cambiar Contraseña'),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleResetPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await widget.databaseHelper.update(
          {
            'id': widget.teacher.id,
            'password': widget.newPasswordController.text,
          },
          'teachers',
        );
        if (!context.mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Contraseña Cambiada'),
              content:
                  const Text('Su contraseña ha sido cambiada exitosamente'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/');
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 50),
        child: const Column(
          children: [
            Image(image: AssetImage('assets/logo.png'), width: 150),
            SizedBox(height: 20),
            Text(
              'Nueva Contraseña',
              style: TextStyle(fontSize: 30, fontFamily: 'NotoSans'),
            )
          ],
        ),
      ),
    );
  }
}

class _Labels extends StatelessWidget {
  const _Labels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => context.pushReplacement('/'),
          child: const Text(
            'Iniciar Sesión',
          ),
        ),
        const SizedBox(height: 20),
        const Image(
          image: AssetImage('assets/umg.png'),
          fit: BoxFit.contain,
          width: 100,
        ),
        const Text('UMG'),
      ],
    );
  }
}

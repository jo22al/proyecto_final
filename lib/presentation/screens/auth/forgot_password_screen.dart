import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_project/config/helpers/validations.dart';
import 'package:memory_project/models/teacher_model.dart';
import 'package:memory_project/presentation/widgets/widgets.dart';

import '../../../data/database_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot_password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
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
                  emailController: emailController,
                  dateOfBirthController: dateOfBirthController,
                  databaseHelper: databaseHelper),
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
  final TextEditingController emailController;
  final TextEditingController dateOfBirthController;
  final DatabaseHelper databaseHelper;

  const _Form({
    Key? key,
    required this.emailController,
    required this.dateOfBirthController,
    required this.databaseHelper,
  }) : super(key: key);

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
              controller: widget.emailController,
              icon: Icons.person_2_outlined,
              keyboardType: TextInputType.emailAddress,
              placeHolder: 'Correo Electronico',
              labelText: const Text('Correo Electronico'),
              validator: (value) {
                String pattern = Validations.patternEmail;
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo no es valido';
              },
            ),
            CustomInput(
              icon: Icons.calendar_today,
              placeHolder: 'Fecha de nacimiento',
              labelText: const Text('Fecha de nacimiento'),
              controller: widget.dateOfBirthController,
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  widget.dateOfBirthController.text =
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
            ElevatedButton(
              onPressed:
                  _isLoading ? null : () => _handleForgotPassword(context),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Recuperar Contraseña'),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleForgotPassword(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String email = widget.emailController.text.trim();
    String dateOfBirth = widget.dateOfBirthController.text.trim();

    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'email': email,
        'dateOfBirth': dateOfBirth,
      };

      Teacher? teacher = await widget.databaseHelper.existsTeacher(data);

      if (teacher != null) {
        if (!context.mounted) return;
        context.go('/reset_password', extra: teacher);
      } else {
        setState(() {
          _errorMessage = 'No se encontro un usuario con esos datos';
        });
      }

      setState(() {
        _isLoading = false;
      });
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
              'Recuperar Contraseña',
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

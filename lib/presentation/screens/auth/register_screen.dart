import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_project/presentation/widgets/widgets.dart';

import '../../../config/helpers/validations.dart';
import '../../../data/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  // Database helper
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const _Logo(),
                _Form(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    nameController: _nameController,
                    lastnameController: _lastnameController,
                    dateOfBirthController: _dateOfBirthController,
                    isPasswordObscured: isPasswordObscured,
                    isConfirmPasswordObscured: isConfirmPasswordObscured,
                    databaseHelper: _databaseHelper),
                const _Labels()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final TextEditingController? nameController;
  final TextEditingController? lastnameController;
  final TextEditingController? dateOfBirthController;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final DatabaseHelper databaseHelper;

  const _Form(
      {required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.nameController,
      required this.lastnameController,
      required this.dateOfBirthController,
      required this.isPasswordObscured,
      required this.isConfirmPasswordObscured,
      required this.databaseHelper});

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
                controller: widget.nameController,
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
                controller: widget.lastnameController,
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
                  widget.dateOfBirthController?.text =
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
            CustomInput(
                controller: widget.passwordController,
                icon: Icons.password_outlined,
                placeHolder: 'Contraseña',
                labelText: const Text('Contraseña'),
                isPassword: widget.isPasswordObscured,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese su contraseña';
                  }
                  return null;
                }),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _handleRegister(context),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Crear Cuenta'),
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

  Future<void> _handleRegister(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'email': widget.emailController!.text.trim(),
        'password': widget.passwordController!.text.trim(),
        'name': widget.nameController!.text.trim(),
        'lastname': widget.lastnameController!.text.trim(),
        'dateOfBirth': widget.dateOfBirthController!.text.trim(),
      };
      int id = await widget.databaseHelper.insert(row, 'teachers');
      debugPrint('Inserted row id: $id');
      if (!context.mounted) return;
      showAlert(context, 'Correcto', 'Usuario creado exitosamente');
      widget.emailController!.clear();
      widget.passwordController!.clear();
      widget.confirmPasswordController!.clear();
      widget.nameController!.clear();
      widget.lastnameController!.clear();
      widget.dateOfBirthController!.clear();
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
              'Crear Cuenta',
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
        const SizedBox(height: 20),
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

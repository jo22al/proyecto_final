import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_project/models/teacher_model.dart';
import 'package:memory_project/data/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/form_input/custom_form_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  String? _savedEmail;
  String? _savedPassword;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedEmail = prefs.getString('email');
      _savedPassword = prefs.getString('password');
    });

    _emailController.text = _savedEmail ?? '';
    _passwordController.text = _savedPassword ?? '';
  }

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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomInput(
                          icon: Icons.email_outlined,
                          controller: _emailController,
                          placeHolder: 'Correo',
                          labelText: const Text('Correo'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, introduzca su email';
                            }
                            return null;
                          },
                        ),
                        CustomInput(
                          icon: Icons.email_outlined,
                          controller: _passwordController,
                          isPassword: true,
                          placeHolder: 'Contraseña',
                          labelText: const Text('Contraseña'),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, introduzca su email';
                            }
                            return null;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Recuérdame'),
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed:
                              _isLoading ? null : () => _handleLogin(context),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Ingresar'),
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
                ),
                const SizedBox(height: 20),
                const _Labels()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    Teacher? teacher =
        await DatabaseHelper.instance.getTeacher(email, password);

    if (teacher != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', teacher.id.toString());
      await prefs.setString('name', teacher.name);
      await prefs.setString('lastName', teacher.lastname);
      if (_rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      }

      if (!context.mounted) return;
      context.pushReplacement('/students');
    } else {
      if (!context.mounted) return;
      setState(() {
        _errorMessage = 'Correo electrónico o contraseña no válidos';
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
              'Iniciar sesión',
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
          onTap: () => context.pushReplacement('/register'),
          child: const Text(
            'Crear Cuenta',
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () => context.pushReplacement('/forgot_password'),
          child: const Text(
            '¿Ha olvidado su contraseña?',
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

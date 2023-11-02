import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Project'),
      ),
      body: Center(
          child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              context.push('/picture_match');
            },
            child: const Text('Memory Match'),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/login');
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/register');
            },
            child: const Text('Register'),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/users');
            },
            child: const Text('Users'),
          ),
        ],
      )),
    );
  }
}

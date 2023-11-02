import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data.dart';
import '../../../models/student_model.dart';
import '../../providers/memory_match_provider.dart';

class StudentGamesLevesScreen extends ConsumerWidget {
  static const String routeName = '/user_game_levels';

  final Student student;

  const StudentGamesLevesScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Selecciona un nivel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LevelButton(
              onPressed: () {
                ref.read(gameProvider.notifier).level(Level.facil);
                context.push('/picture_match', extra: student);
              },
              title: 'Facil',
              noOfstar: 1,
            ),
            const SizedBox(height: 20),
            LevelButton(
              onPressed: () {
                ref.read(gameProvider.notifier).level(Level.medio);
                context.push('/picture_match', extra: student);
              },
              title: 'Medio',
              noOfstar: 2,
            ),
            const SizedBox(height: 20),
            LevelButton(
              onPressed: () {
                ref.read(gameProvider.notifier).level(Level.dificil);
                context.push('/picture_match', extra: student);
              },
              title: 'Dificil',
              noOfstar: 3,
            ),
          ],
        )),
      ),
    );
  }
}

class LevelButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final int noOfstar;

  const LevelButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.noOfstar,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 20)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: genratestar(noOfstar))
            ],
          ),
        ));
  }

  List<Widget> genratestar(int no) {
    List<Widget> icons = [];
    for (int i = 0; i < no; i++) {
      icons.insert(
          i,
          const Icon(
            Icons.star,
          ));
    }
    return icons;
  }
}

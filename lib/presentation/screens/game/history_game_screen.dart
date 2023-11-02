import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/helpers/helpers.dart';
import '../../../data/database_helper.dart';
import '../../../models/scores_model.dart';
import '../../../models/student_model.dart';

class HistoryGameScreen extends StatefulWidget {
  static const String routeName = '/history_game_screen';

  final Student student;

  const HistoryGameScreen({super.key, required this.student});

  @override
  State<HistoryGameScreen> createState() => _HistoryGameScreenState();
}

class _HistoryGameScreenState extends State<HistoryGameScreen> {
  List<Score> scors = [];

  @override
  void initState() {
    super.initState();
    _getScore(widget.student.id);
  }

  @override
  Widget build(BuildContext context) {
    final isInForeground = ModalRoute.of(context)?.isCurrent ?? false;

    if (isInForeground) {
      _getScore(widget.student.id);
    }

    if (scors.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Historial de juegos'),
        ),
        body: ListView.separated(
          itemCount: scors.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (context, index) {
            final score = scors[index];
            DateTime parsedDate = DateTime.parse(score.currentDate);
            String formattedDate =
                DateFormat('yyyy-MM-dd – kk:mm a').format(parsedDate);

            return ListTile(
              title: Text('Nivel: ${score.level}'),
              subtitle: Text(formattedDate),
              trailing: Text(
                  'Tiempo: ${formatDuration(Duration(seconds: score.time))}',
                  style: const TextStyle(fontSize: 14)),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Historial de juegos'),
        ),
        body: const Center(
          child: Text('No hay juegos registrados'),
        ),
      );
    }
  }

  void _getScore(int id) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final List<Score> scores = await databaseHelper.getScoreByStudent(id);
    setState(() {
      scors = scores;
    });
  }
}

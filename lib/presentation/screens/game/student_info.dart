import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/helpers/helpers.dart';
import '../../../data/database_helper.dart';
import '../../../models/scores_model.dart';
import '../../../models/student_model.dart';

class StudentInfoScreen extends StatefulWidget {
  static const String routeName = '/student_info_screen';

  final Student student;

  const StudentInfoScreen({super.key, required this.student});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  List<Score> scors = [];

  @override
  void initState() {
    super.initState();
    _getScore(widget.student.id);
  }

  @override
  Widget build(BuildContext context) {
    String dateString = widget.student.dateOfBirth;
    DateFormat format = DateFormat('MM/dd/yyyy');
    DateTime date = format.parse(dateString);

    final isInForeground = ModalRoute.of(context)?.isCurrent ?? false;

    if (isInForeground) {
      _getScore(widget.student.id);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Información del estudiante'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 100,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.student.name} ${widget.student.lastname}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Código: ${widget.student.codigo}',
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Edad: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${calculateAge(date)} años',
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Fecha de nacimiento: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.student.dateOfBirth,
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Maestro(a): ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.student.teacherName} ${widget.student.teacherLastname}',
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                InkWell(
                  onTap: () => context.pushNamed('/history_game_screen',
                      extra: widget.student),
                  child: Center(
                    child: Card(
                        child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: const Text(
                        'Ver historial de tiempos',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
                  ),
                ),
                const Center(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Mejores Tiempos',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text('Facil',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              formatDuration(Duration(
                                  seconds: widget.student.bestEasyLevel)),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text('Medio',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              formatDuration(
                                Duration(
                                    seconds: widget.student.bestMediumLevel),
                              ),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text('Dificil',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              formatDuration(Duration(
                                  seconds: widget.student.bestHardLevel)),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Center(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Progreso de tiempos',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )),
                ScoreLineChart(scores: scors),
              ],
            ),
          ),
        ));
  }

  int calculateAge(DateTime dateOfBirth) {
    DateTime now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  void _getScore(int id) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final List<Score> scores = await databaseHelper.getScoreByStudent(id);
    setState(() {
      scors = scores;
    });
  }
}

class ScoreLineChart extends StatelessWidget {
  final List<Score> scores;

  ScoreLineChart({required this.scores});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = scores
        .map((score) => FlSpot(score.id.toDouble(), score.time.toDouble()))
        .toList();

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 300,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(spots: spots),
          ],
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text;
  switch (value.toInt()) {
    case 2:
      text = const Text('MAR', style: style);
      break;
    case 5:
      text = const Text('JUN', style: style);
      break;
    case 8:
      text = const Text('SEP', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  switch (value.toInt()) {
    case 1:
      text = '10K';
      break;
    case 3:
      text = '30k';
      break;
    case 5:
      text = '50k';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}

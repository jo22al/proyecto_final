import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/helpers/helpers.dart';
import '../../../data.dart';
import '../../../data/database_helper.dart';
import '../../../models/student_model.dart';
import '../../providers/memory_match_provider.dart';

class MemoryMatchScreen extends ConsumerStatefulWidget {
  static const routeName = '/memory_match';
  final Student student;

  const MemoryMatchScreen({super.key, required this.student});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends ConsumerState<MemoryMatchScreen> {
  int _previousIndex = -1;
  bool _flip = false;
  bool _start = false;

  bool _wait = false;
  late Timer _timer;
  Timer _timerGame = Timer.periodic(const Duration(seconds: 1), (t) {});
  late int _totalTimeGame = 0;
  late int _time = 5;
  late int _left;
  late bool _isFinished;
  late List<dynamic> _data;

  late List<bool> _cardFlips;
  late List<GlobalKey<FlipCardState>> _cardStateKeys;

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          _time = _time - 1;
        });
      }
    });
  }

  startTotalTimeGame() {
    _timerGame = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          _totalTimeGame = _totalTimeGame + 1;
        });
      }
    });
  }

  void restart() {
    startTimer();
    _data = getSourceArray(
        ref.watch(gameProvider).level, ref.watch(gameProvider).sourceArrayList);
    _cardFlips = getInitialItemState(ref.watch(gameProvider).level);
    _cardStateKeys = getCardStateKeys(ref.watch(gameProvider).level);
    _time = 5;
    _totalTimeGame = 0;
    _left = (_data.length ~/ 2);

    _isFinished = false;
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _start = true;
          _timer.cancel();
          startTotalTimeGame();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    restart();
  }

  @override
  void dispose() {
    if (_timerGame.isActive) {
      _timerGame.cancel();
    }
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;

    void updateTimeStudent(int idStudent, Level level, int totalTime) async {
      String columnToUpdate;

      switch (level) {
        case Level.facil:
          columnToUpdate = 'bestEasyLevel';
          ref.read(gameProvider.notifier).bestEasyLevel(totalTime);
          break;
        case Level.medio:
          columnToUpdate = 'bestMediumLevel';
          ref.read(gameProvider.notifier).bestMediumLevel(totalTime);
          break;
        case Level.dificil:
          columnToUpdate = 'bestHardLevel';
          ref.read(gameProvider.notifier).bestHardLevel(totalTime);
          break;
        default:
          return;
      }

      Map<String, dynamic> row = {'id': idStudent, columnToUpdate: totalTime};

      int id = await databaseHelper.update(row, 'students');
      debugPrint('inserted row id: $id');
    }

    void saveScore(int time, String level, String currentDate,
        String currentTime, int studentId) async {
      Map<String, dynamic> row = {
        'time': time,
        'level': level,
        'currentDate': currentDate,
        'currentTime': currentTime,
        'student_id': studentId,
      };

      int id = await databaseHelper.insert(row, 'scores');
      debugPrint('inserted row id: $id');
    }

    Widget bestTime;
    if (ref.watch(gameProvider).level == Level.facil) {
      bestTime = Text(
          'Mejor Tiempo: ${formatDuration(Duration(seconds: ref.watch(gameProvider).bestEasyLevel))}');
    } else if (ref.watch(gameProvider).level == Level.medio) {
      bestTime = Text(
          'Mejor Tiempo: ${formatDuration(Duration(seconds: ref.watch(gameProvider).bestMediumLevel))}');
    } else {
      bestTime = Text(
          'Mejor Tiempo: ${formatDuration(Duration(seconds: ref.watch(gameProvider).bestHardLevel))}');
    }

    final duration = Duration(seconds: _totalTimeGame);
    final formattedDuration =
        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    return Scaffold(
      body: _isFinished
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Consumer(
                  builder: (context, ref, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const Image(
                                  fit: BoxFit.cover,
                                  width: 200,
                                  image: AssetImage(
                                    'assets/confeti.png',
                                  )),
                              const SizedBox(height: 60),
                              Text(
                                '¡Felicidades! ${widget.student.name} ${widget.student.lastname}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Has completado el nivel ${ref.watch(gameProvider).level.toString().split('.').last}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Tiempo: ${formatDuration(Duration(seconds: _totalTimeGame))}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Mejor tiempo: ${formatDuration(Duration(seconds: ref.watch(gameProvider).level == Level.facil ? ref.watch(gameProvider).bestEasyLevel : ref.watch(gameProvider).level == Level.medio ? ref.watch(gameProvider).bestMediumLevel : ref.watch(gameProvider).bestHardLevel))}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                restart();
                              });
                            }
                          },
                          child: const Text('Jugar de nuevo'),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            restart();
                            context.go('/category_screen',
                                extra: widget.student);
                          },
                          child: const Text('Categorias'),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            restart();
                            context.go('/students');
                          },
                          child: const Text('Inicio'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        bestTime,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _time <= 0
                                ? Text(
                                    "Tiempo: $formattedDuration",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  )
                                : Text(
                                    "Memoriza: $_time",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                            Text(
                              "Faltan: $_left",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) => _start
                          ? FlipCard(
                              key: _cardStateKeys[index],
                              onFlip: () async {
                                if (!_flip) {
                                  _flip = true;
                                  _previousIndex = index;
                                } else {
                                  _flip = false;
                                  if (_previousIndex != index) {
                                    if (_data[_previousIndex] != _data[index]) {
                                      _wait = true;
                                      Future.delayed(
                                          const Duration(milliseconds: 1500),
                                          () {
                                        _cardStateKeys[_previousIndex]
                                            .currentState
                                            ?.toggleCard();
                                        _previousIndex = index;
                                        _cardStateKeys[_previousIndex]
                                            .currentState
                                            ?.toggleCard();

                                        Future.delayed(
                                            const Duration(milliseconds: 160),
                                            () {
                                          if (mounted) {
                                            setState(() {
                                              _wait = false;
                                            });
                                          }
                                        });
                                      });
                                    } else {
                                      _cardFlips[_previousIndex] = false;
                                      _cardFlips[index] = false;
                                      print(_cardFlips);

                                      if (mounted) {
                                        setState(() {
                                          _left -= 1;
                                        });
                                      }

                                      if (_cardFlips.every((t) => t == false)) {
                                        _timerGame.cancel();
                                        debugPrint("Won");
                                        saveScore(
                                            _totalTimeGame,
                                            ref
                                                .watch(gameProvider)
                                                .level
                                                .toString()
                                                .split('.')
                                                .last,
                                            DateTime.now().toString(),
                                            formattedTime,
                                            widget.student.id);

                                        if (ref.watch(gameProvider).level ==
                                                Level.facil &&
                                            ref
                                                    .watch(gameProvider)
                                                    .bestEasyLevel ==
                                                0) {
                                          updateTimeStudent(widget.student.id,
                                              Level.facil, _totalTimeGame);
                                        }

                                        if (ref.watch(gameProvider).level ==
                                                Level.medio &&
                                            ref
                                                    .watch(gameProvider)
                                                    .bestMediumLevel ==
                                                0) {
                                          updateTimeStudent(widget.student.id,
                                              Level.medio, _totalTimeGame);
                                        }

                                        if (ref.watch(gameProvider).level ==
                                                Level.dificil &&
                                            ref
                                                    .watch(gameProvider)
                                                    .bestHardLevel ==
                                                0) {
                                          updateTimeStudent(widget.student.id,
                                              Level.dificil, _totalTimeGame);
                                        }

                                        ///////////////////////////////////////////////////////////

                                        if (ref.watch(gameProvider).level ==
                                                Level.facil &&
                                            ref
                                                    .watch(gameProvider)
                                                    .bestEasyLevel >
                                                _totalTimeGame) {
                                          updateTimeStudent(widget.student.id,
                                              Level.facil, _totalTimeGame);
                                        }

                                        if (ref.watch(gameProvider).level ==
                                                Level.medio &&
                                            ref
                                                    .watch(gameProvider)
                                                    .bestMediumLevel >
                                                _totalTimeGame) {
                                          updateTimeStudent(widget.student.id,
                                              Level.medio, _totalTimeGame);
                                        }

                                        if (ref.watch(gameProvider).level ==
                                                Level.dificil &&
                                            ref
                                                    .watch(gameProvider)
                                                    .bestHardLevel >
                                                _totalTimeGame) {
                                          updateTimeStudent(widget.student.id,
                                              Level.dificil, _totalTimeGame);
                                        }

                                        Future.delayed(
                                            const Duration(milliseconds: 160),
                                            () {
                                          if (mounted) {
                                            setState(() {
                                              _isFinished = true;
                                              _start = false;
                                            });
                                          }
                                        });
                                      }
                                    }
                                  }
                                }
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              flipOnTouch: _wait ? false : _cardFlips[index],
                              direction: FlipDirection.HORIZONTAL,
                              front: Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.question_mark_outlined,
                                      size: 80,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4),
                                    )),
                              ),
                              back: GetItem(image: _data[index]),
                            )
                          : GetItem(image: _data[index]),
                      itemCount: _data.length,
                    ),
                  )
                  //Create an counter in the top of the screen in container
                ]),
              ),
            ),
    );
  }
}

class GetItem extends StatelessWidget {
  final String image;

  const GetItem({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(image),
        ));
  }
}

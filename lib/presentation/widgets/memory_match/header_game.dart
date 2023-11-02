import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data.dart';
import '../../../models/student_model.dart';
import '../../providers/memory_match_provider.dart';

class HeaderGame extends ConsumerStatefulWidget {
  final Student student;
  final int time;

  const HeaderGame(this.time, {super.key, required this.student});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderGameState();
}

class _HeaderGameState extends ConsumerState<HeaderGame> {
  @override
  Widget build(BuildContext context) {
    final level = ref.watch(gameProvider).level;

    Widget bestTime;
    if (level == Level.facil) {
      bestTime = Text('Mejor Tiempo: ${ref.watch(gameProvider).bestEasyLevel}');
    } else if (level == Level.medio) {
      bestTime =
          Text('Mejor Tiempo: ${ref.watch(gameProvider).bestMediumLevel}');
    } else {
      bestTime = Text('Mejor Tiempo: ${ref.watch(gameProvider).bestHardLevel}');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          bestTime,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              widget.time <= 0
                  ? Consumer(
                      builder: (context, watch, _) {
                        final totalTimeInSeconds =
                            ref.watch(gameProvider).totalTime;
                        final duration = Duration(seconds: totalTimeInSeconds);
                        final formattedDuration =
                            '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
                        return Text(
                          "Tiempo Total: $formattedDuration",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        );
                      },
                    )
                  : Consumer(
                      builder: (context, watch, _) {
                        return Text(
                          "Memoriza: $widget.time",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        );
                      },
                    ),
              Consumer(
                builder: (context, watch, _) {
                  final left = ref.watch(gameProvider).left;
                  return Text(
                    "Faltan: $left",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

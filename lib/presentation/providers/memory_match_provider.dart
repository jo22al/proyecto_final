import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data.dart';

final gameProvider =
    StateNotifierProvider<GameNotifier, Game>((ref) => GameNotifier());

class GameNotifier extends StateNotifier<Game> {
  GameNotifier() : super(Game());

  Timer? _timer;
  Timer? _timerTotal;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(time: state.time - 1);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void startTimerTotal() {
    _timerTotal = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(totalTime: state.totalTime + 1);
    });
  }

  void stopTimerTotal() {
    _timerTotal?.cancel();
    _timerTotal = null;
  }

  void restart() {
    stopTimer();
    stopTimerTotal();
    state = state.copyWith(
        data: getSourceArray(state.level, state.sourceArrayList),
        cardFlips: getInitialItemState(state.level),
        cardStateKeys: getCardStateKeys(state.level),
        time: 5,
        left: (getSourceArray(state.level, state.sourceArrayList).length ~/ 2),
        isFinished: false,
        start: false,
        totalTime: 0);
    startTimer();

    Future.delayed(const Duration(seconds: 6), () {
      stopTimer();
      state = state.copyWith(start: true);
      startTimerTotal();
    });
  }

  void flip(bool value) {
    state = state.copyWith(flip: value);
  }

  void wait(bool value) {
    state = state.copyWith(wait: value);
  }

  void previusIndex(int value) {
    state = state.copyWith(previousIndex: value);
  }

  void isFinished(bool value) {
    state = state.copyWith(isFinished: value);
  }

  void start(bool value) {
    state = state.copyWith(start: value);
  }

  void left(int value) {
    state = state.copyWith(left: value);
  }

  void level(Level value) {
    state = state.copyWith(level: value);
  }

  void sourceArrayList(List value) {
    state = state.copyWith(sourceArrayList: value);
  }

  void bestEasyLevel(int value) {
    state = state.copyWith(bestEasyLevel: value);
  }

  void bestMediumLevel(int value) {
    state = state.copyWith(bestMediumLevel: value);
  }

  void bestHardLevel(int value) {
    state = state.copyWith(bestHardLevel: value);
  }
}

class Game {
  final Level level;
  final List<dynamic> data;
  final List<bool> cardFlips;
  final List<GlobalKey<FlipCardState>> cardStateKeys;
  final List sourceArrayList;
  final int time;
  final int left;
  final bool isFinished;
  final bool start;
  final int previousIndex;
  final bool flip;
  final bool wait;
  final int totalTime;
  final int bestEasyLevel;
  final int bestMediumLevel;
  final int bestHardLevel;

  Game({
    this.level = Level.facil,
    this.data = const [],
    this.cardFlips = const [],
    this.cardStateKeys = const [],
    this.sourceArrayList = const [],
    this.time = 0,
    this.left = 0,
    this.isFinished = false,
    this.start = false,
    this.previousIndex = -1,
    this.flip = false,
    this.wait = false,
    this.totalTime = 0,
    this.bestEasyLevel = 0,
    this.bestMediumLevel = 0,
    this.bestHardLevel = 0,
  });

  Game copyWith({
    Level? level,
    List<dynamic>? data,
    List<bool>? cardFlips,
    List<GlobalKey<FlipCardState>>? cardStateKeys,
    List? sourceArrayList,
    int? time,
    int? left,
    bool? isFinished,
    bool? start,
    int? previousIndex,
    bool? flip,
    bool? wait,
    int? totalTime,
    int? bestEasyLevel,
    int? bestMediumLevel,
    int? bestHardLevel,
  }) {
    return Game(
      level: level ?? this.level,
      data: data ?? this.data,
      cardFlips: cardFlips ?? this.cardFlips,
      cardStateKeys: cardStateKeys ?? this.cardStateKeys,
      sourceArrayList: sourceArrayList ?? this.sourceArrayList,
      time: time ?? this.time,
      left: left ?? this.left,
      isFinished: isFinished ?? this.isFinished,
      start: start ?? this.start,
      previousIndex: previousIndex ?? this.previousIndex,
      flip: flip ?? this.flip,
      wait: wait ?? this.wait,
      totalTime: totalTime ?? this.totalTime,
      bestEasyLevel: bestEasyLevel ?? this.bestEasyLevel,
      bestMediumLevel: bestMediumLevel ?? this.bestMediumLevel,
      bestHardLevel: bestHardLevel ?? this.bestHardLevel,
    );
  }
}

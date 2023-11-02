import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

enum Level { facil, medio, dificil }

List<String> fillSourceArray() {
  return [
    'assets/animalspics/dino.png',
    'assets/animalspics/dino.png',
    'assets/animalspics/wolf.png',
    'assets/animalspics/wolf.png',
    'assets/animalspics/peacock.png',
    'assets/animalspics/peacock.png',
    'assets/animalspics/whale.png',
    'assets/animalspics/whale.png',
    'assets/animalspics/octo.png',
    'assets/animalspics/octo.png',
    'assets/animalspics/fish.png',
    'assets/animalspics/fish.png',
    'assets/animalspics/frog.png',
    'assets/animalspics/frog.png',
    'assets/animalspics/seahorse.png',
    'assets/animalspics/seahorse.png',
    'assets/animalspics/girraf.png',
    'assets/animalspics/girraf.png',
  ];
}

List<String> formasSourceArray() {
  return [
    'assets/geometrics/circle1.png',
    'assets/geometrics/circle1.png',
    'assets/geometrics/circle2.png',
    'assets/geometrics/circle2.png',
    'assets/geometrics/cube1.png',
    'assets/geometrics/cube1.png',
    'assets/geometrics/cylinder.png',
    'assets/geometrics/cylinder.png',
    'assets/geometrics/hexagon2.png',
    'assets/geometrics/hexagon2.png',
    'assets/geometrics/prism.png',
    'assets/geometrics/prism.png',
    'assets/geometrics/rectangle1.png',
    'assets/geometrics/rectangle1.png',
    'assets/geometrics/star2.png',
    'assets/geometrics/star2.png',
    'assets/geometrics/triangle2.png',
    'assets/geometrics/triangle2.png',
  ];
}

List<String> homecategory() {
  return[
    'assets/home/chair.png',
    'assets/home/chair.png',
    'assets/home/chef.png',
    'assets/home/chef.png',
    'assets/home/cooking.png',
    'assets/home/cooking.png',
    'assets/home/cutlery.png',
    'assets/home/cutlery.png',
    'assets/home/fridge.png',
    'assets/home/fridge.png',
    'assets/home/frying.png',
    'assets/home/frying.png',
    'assets/home/house1.png',
    'assets/home/house1.png',
    'assets/home/microwave.png',
    'assets/home/microwave.png',
    'assets/home/table.png',
    'assets/home/table.png',
  ];
}

List<String> profesionscategory() {
  return[
    'assets/profesions/athlete.png',
    'assets/profesions/athlete.png',
    'assets/profesions/chef.png',
    'assets/profesions/chef.png',
    'assets/profesions/doctor.png',
    'assets/profesions/doctor.png',
    'assets/profesions/electric.png',
    'assets/profesions/electric.png',
    'assets/profesions/engineer.png',
    'assets/profesions/engineer.png',
    'assets/profesions/teacher.png',
    'assets/profesions/teacher.png',
    'assets/profesions/farmer.png',
    'assets/profesions/farmer.png',
    'assets/profesions/musician.png',
    'assets/profesions/musician.png',
    'assets/profesions/police.png',
    'assets/profesions/police.png',
  ];
}

List<String> toyscategory() {
  return[
    'assets/toys/basket.png',
    'assets/toys/basket.png',
    'assets/toys/soccer.png',
    'assets/toys/soccer.png',
    'assets/toys/beart.png',
    'assets/toys/beart.png',
    'assets/toys/boxt.png',
    'assets/toys/boxt.png',
    'assets/toys/duck.png',
    'assets/toys/duck.png',
    'assets/toys/pyramid.png',
    'assets/toys/pyramid.png',
    'assets/toys/t-car.png',
    'assets/toys/t-car.png',
    'assets/toys/toys.png',
    'assets/toys/toys.png',
    'assets/toys/toy-car.png',
    'assets/toys/toy-car.png',
  ];
}

List<String> transportscategory() {
  return[
    'assets/transports/airplane.png',
    'assets/transports/airplane.png',
    'assets/transports/boat.png',
    'assets/transports/boat.png',
    'assets/transports/bus.png',
    'assets/transports/bus.png',
    'assets/transports/car1.png',
    'assets/transports/car1.png',
    'assets/transports/pickup.png',
    'assets/transports/pickup.png',
    'assets/transports/train.png',
    'assets/transports/train.png',
    'assets/transports/shipped.png',
    'assets/transports/shipped.png',
    'assets/transports/plane.png',
    'assets/transports/plane.png',
    'assets/transports/bus-stop.png',
    'assets/transports/bus-stop.png',
  ];
}

List getSourceArray(Level level, List sourceArrayList) {
  List<String> levelAndKindList = [];
  List sourceArray = sourceArrayList;
  if (level == Level.dificil) {
    for (var element in sourceArray) {
      levelAndKindList.add(element);
    }
  } else if (level == Level.medio) {
    for (int i = 0; i < 12; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  } else if (level == Level.facil) {
    for (int i = 0; i < 6; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  }

  levelAndKindList.shuffle();
  return levelAndKindList;
}

List<bool> getInitialItemState(Level level) {
  List<bool> initialItemState = [];
  if (level == Level.dificil) {
    for (int i = 0; i < 18; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.medio) {
    for (int i = 0; i < 12; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.facil) {
    for (int i = 0; i < 6; i++) {
      initialItemState.add(true);
    }
  }
  return initialItemState;
}

List<GlobalKey<FlipCardState>> getCardStateKeys(Level level) {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  if (level == Level.dificil) {
    for (int i = 0; i < 18; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == Level.medio) {
    for (int i = 0; i < 12; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == Level.facil) {
    for (int i = 0; i < 6; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  }
  return cardStateKeys;
}

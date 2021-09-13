import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';

class Statistics {
  Statistics({this.exam});

  final Exam? exam;

  late Level veryGood = Level.veryGood();
  late Level good = Level.good();
  late Level average = Level.average();
  late Level weak = Level.weak();
  late Level poor = Level.poor();

  int get maxAnswer => exam?.result.length ?? 1;

  double get percentVeryGood => levelCount(LevelType.VeryGood) / maxAnswer;
  double get percentGood => levelCount(LevelType.Good) / maxAnswer;
  double get percentAverage => levelCount(LevelType.Average) / maxAnswer;
  double get percentWeak => levelCount(LevelType.Weak) / maxAnswer;
  double get percentPoor => levelCount(LevelType.Poor) / maxAnswer;

  int levelCount(LevelType type) {
    int count = 0;
    double nextPoint = 0;
    double minPoint = 0;

    switch (type) {
      case LevelType.VeryGood:
        nextPoint = (exam?.maxPoint ?? 0) + 1;
        minPoint = (veryGood.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        break;
      case LevelType.Good:
        nextPoint = (veryGood.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        minPoint = (good.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        break;
      case LevelType.Average:
        nextPoint = (good.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        minPoint = (average.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        break;
      case LevelType.Weak:
        nextPoint = (average.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        minPoint = (weak.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        break;
      case LevelType.Poor:
        nextPoint = (weak.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        minPoint = (poor.minPerent ?? 0) * (exam?.maxPoint ?? 0);
        break;
    }
    exam?.result.forEach((element) {
      if (nextPoint > element.point && element.point >= minPoint) {
        count++;
      }
    });

    return count;
  }
}

enum LevelType { VeryGood, Good, Average, Weak, Poor }

class Level {
  Level({this.type, this.color, this.count, this.max, this.minPerent});

  final LevelType? type;
  final Color? color;
  final int? count;
  final int? max;
  final double? minPerent;

  double get percent => (count ?? 0) / (max ?? 1);

  factory Level.veryGood({int? count, int? max}) => Level(
      type: LevelType.VeryGood,
      color: ResourceManager().color.good,
      count: count,
      minPerent: 0.8,
      max: max);

  factory Level.good({int? count, int? max}) => Level(
      type: LevelType.Good,
      color: ResourceManager().color.pretty,
      count: count,
      minPerent: 0.65,
      max: max);

  factory Level.average({int? count, int? max}) => Level(
      type: LevelType.Average,
      color: ResourceManager().color.average,
      count: count,
      minPerent: 0.5,
      max: max);

  factory Level.weak({int? count, int? max}) => Level(
      type: LevelType.Weak,
      color: ResourceManager().color.weak,
      count: count,
      minPerent: 0.4,
      max: max);

  factory Level.poor({int? count, int? max}) => Level(
      type: LevelType.Poor,
      color: ResourceManager().color.poor,
      count: count,
      minPerent: 0,
      max: max);
}

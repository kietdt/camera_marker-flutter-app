import 'dart:math';

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

  int get maxResult => max(exam?.result.length ?? 1, 1);

  double get percentVeryGood => levelCount(LevelType.VeryGood) / maxResult;
  double get percentGood => levelCount(LevelType.Good) / maxResult;
  double get percentAverage => levelCount(LevelType.Average) / maxResult;
  double get percentWeak => levelCount(LevelType.Weak) / maxResult;
  double get percentPoor => levelCount(LevelType.Poor) / maxResult;

  int get countVeryGood => levelCount(LevelType.VeryGood);
  int get countGood => levelCount(LevelType.Good);
  int get countAverage => levelCount(LevelType.Average);
  int get countWeak => levelCount(LevelType.Weak);
  int get countPoor => levelCount(LevelType.Poor);

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
  Level(
      {this.type,
      this.color = Colors.white,
      this.minPerent,
      this.description = ""});

  final LevelType? type;
  final Color color;
  final double? minPerent;
  final String description;

  factory Level.veryGood() => Level(
        type: LevelType.VeryGood,
        color: ResourceManager().color.veryGood,
        minPerent: 0.8,
        description: "Giỏi",
      );

  factory Level.good() => Level(
        type: LevelType.Good,
        color: ResourceManager().color.good,
        minPerent: 0.65,
        description: "Khá",
      );

  factory Level.average() => Level(
        type: LevelType.Average,
        color: ResourceManager().color.average,
        minPerent: 0.5,
        description: "Trung bình",
      );

  factory Level.weak() => Level(
        type: LevelType.Weak,
        color: ResourceManager().color.weak,
        minPerent: 0.4,
        description: "Yếu",
      );

  factory Level.poor() => Level(
        type: LevelType.Poor,
        color: ResourceManager().color.poor,
        minPerent: 0,
        description: "Kém",
      );
}

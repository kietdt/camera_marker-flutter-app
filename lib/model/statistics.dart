import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';

class Statistics {
  Statistics({this.exam});

  final Exam? exam;

  int levelCount(LevelType type) {
    int count = 0;

    switch (type) {
      case LevelType.Good:
        break;
      case LevelType.Pretty:
        break;
      case LevelType.Average:
        break;
      case LevelType.Weak:
        break;
      case LevelType.Poor:
        break;
    }

    return count;
  }
}

enum LevelType { Good, Pretty, Average, Weak, Poor }

class Level {
  Level({this.type, this.color, this.count, this.max, this.minPoint});

  final LevelType? type;
  final Color? color;
  final int? count;
  final int? max;
  final double? minPoint;

  double get percent => (count ?? 0) / (max ?? 1);

  factory Level.good({int? count, int? max}) => Level(
      type: LevelType.Good,
      color: ResourceManager().color.good,
      count: count,
      minPoint: 8.0,
      max: max);

  factory Level.pretty({int? count, int? max}) => Level(
      type: LevelType.Pretty,
      color: ResourceManager().color.pretty,
      count: count,
      minPoint: 6.5,
      max: max);

  factory Level.average({int? count, int? max}) => Level(
      type: LevelType.Average,
      color: ResourceManager().color.average,
      count: count,
      minPoint: 5.0,
      max: max);

  factory Level.weak({int? count, int? max}) => Level(
      type: LevelType.Weak,
      color: ResourceManager().color.weak,
      count: count,
      minPoint: 4.0,
      max: max);

  factory Level.poor({int? count, int? max}) => Level(
      type: LevelType.Poor,
      color: ResourceManager().color.poor,
      count: count,
      minPoint: 0,
      max: max);
}

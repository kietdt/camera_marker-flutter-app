import 'dart:io';

import 'package:camera_marker/database/database_ctr.dart';

import 'answer.dart';
import 'exam.dart';

//created by kietdt 06/09/2021
//contact email: dotuankiet1403@gmail.com
class Result {
  String? id;
  String? examId;
  String? examCode; // mã đề, một kì thi có nhiều mã đề
  String? studentCode;
  List<AnswerValue?>? value;
  int? correct;
  String? image;
  int? question;

  String pngPath = "";
  String get pngName => "$studentCode-$examCode.png";

  //Bài thì sẽ không chỉnh sửa được
  //Nên sẽ không có updated date
  DateTime? createdAt;

  double? get maxPoint => DataBaseCtr().tbExam.getById(examId)?.maxPoint;
  double get point => ((maxPoint ?? 0) / (question ?? 1)) * (correct ?? 0);

  Result(
      {this.id,
      this.examId,
      this.examCode,
      this.studentCode,
      this.value,
      this.correct,
      this.question,
      this.createdAt});

  Result.fromJson(Map json) {
    this.id = json["id"];
    this.examId = json["examId"];
    this.examCode = json["examCode"];
    this.studentCode = json["studentCode"];
    this.correct = json["correct"];
    this.image = json["image"];
    this.question = json["question"];
    this.value = json["value"] != null
        ? List<AnswerValue>.from(
            json["value"].map((e) => AnswerValue.fromJson(e)))
        : [];
    this.createdAt =
        json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null;
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "examId": this.examId,
        "examCode": this.examCode,
        "studentCode": this.studentCode,
        "correct": this.correct,
        "maxPoint": this.maxPoint,
        "question": this.question,
        "image": this.image,
        "value": List<Map<String, dynamic>>.from(
            this.value?.map((e) => e?.toJson()) ?? []),
        "createdAt": this.createdAt?.toIso8601String(),
      };

  //model mẫu để test
  //sau này scan được sẽ xóa đi

  static Map<String, dynamic> result1 = {
    "examCode": "005",
    "studentCode": "123",
    "image": "",
    "value": [
      {"valueString": "A B"},
      {"valueString": "B C"},
      {"valueString": "C D"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
    ],
  };

  static Map<String, dynamic> result2 = {
    "examCode": "004",
    "studentCode": "124",
    "image": "",
    "value": [
      {"valueString": "C"},
      {"valueString": "D"},
      {"valueString": "B"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
    ],
  };

  static Map<String, dynamic> result3 = {
    "examCode": "002",
    "studentCode": "125",
    "image": "",
    "value": [
      {"valueString": "C"},
      {"valueString": "D"},
      {"valueString": "D"},
      {"valueString": "D"},
      {"valueString": "D"},
      {"valueString": "C"},
      {"valueString": "D"},
      {"valueString": "D"},
      {"valueString": "D"},
      {"valueString": "D"},
    ],
  };

  static Map<String, dynamic> result4 = {
    "examCode": "004",
    "studentCode": "127",
    "image": "",
    "value": [
      {"valueString": "C"},
      {"valueString": "D"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
    ],
  };

  static Map<String, dynamic> result5 = {
    "examCode": "024",
    "studentCode": "129",
    "image": "",
    "value": [
      {"valueString": "C"},
      {"valueString": "D"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A C"},
      {"valueString": "A A"},
      {"valueString": "B"},
      {"valueString": "A D"},
      {"valueString": "A"},
      {"valueString": "A"},
    ],
  };

  static Map<String, dynamic> result6 = {
    "examCode": "024",
    "studentCode": "115",
    "image": "",
    "value": [
      {"valueString": "C"},
      {"valueString": "D"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "B"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
    ],
  };
}

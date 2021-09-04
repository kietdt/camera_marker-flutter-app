import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/model/config.dart';

class Exam {
  Exam(
      {this.id,
      this.title,
      this.question,
      this.myClassId,
      this.maxPoint,
      this.templateId,
      this.startAt,
      this.minutes});

  String? id;
  String? title;
  int? question;
  String? myClassId;
  double? maxPoint;
  int? templateId;
  DateTime? startAt;
  int? minutes;

  List<String>? answerIds;

  int get maxQuestions => 200;

  String get minutesText => "$minutes phút";

  MyClass? get myClass => DataBaseCtr().tbClass.getById(myClassId);

  Template? get template => DataBaseCtr().tbTemplate.getById(templateId);

  List<Answer> get answer => List<Answer>.from(DataBaseCtr()
      .tbAnswer
      .entities
      .where((element) => (answerIds ?? []).contains(element.id)));

  static List<int> questionsSelect =
      List<int>.generate(200, (index) => index + 1);

  Exam.fromJson(Map json) {
    this.id = json["id"];
    this.title = json["title"];
    this.question = json["question"];
    this.myClassId = json["myClassId"];
    this.maxPoint = json["maxPoint"];
    this.templateId = json["templateId"];
    this.startAt = json["startAt"] != null
        ? DateTime.parse(json["startAt"]).toLocal()
        : null;
    this.minutes = json["minutes"];
    this.answerIds = json["answerIds"] != null
        ? List<String>.from(json["answerIds"].map((e) => e))
        : [];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "question": question,
        "myClassId": myClassId,
        "maxPoint": maxPoint,
        "templateId": templateId,
        "startAt": startAt?.toIso8601String(),
        "minutes": minutes,
        "answerIds": this.answerIds
      };
}

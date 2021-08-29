import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/model/config.dart';

class Exam {
  Exam(
      {this.id,
      this.title,
      this.question,
      this.myClass,
      this.maxPoint,
      this.template,
      this.startAt,
      this.minutes});

  String? id;
  String? title;
  int? question;
  MyClass? myClass;
  double? maxPoint;
  Template? template;
  DateTime? startAt;
  int? minutes;

  int get maxQuestions => 200;

  static List<int> questionsSelect =
      List<int>.generate(200, (index) => index + 1);

  Exam.fromJson(Map json) {
    this.id = json["id"];
    this.title = json["title"];
    this.question = json["question"];
    this.myClass = json["myClass"];
    this.maxPoint = json["maxPoint"];
    this.template = json["template"];
    this.startAt = json["startAt"] != null
        ? DateTime.parse(json["startAt"]).toLocal()
        : null;
    this.minutes = json["minutes"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "question": question,
        "myClass": myClass,
        "maxPoint": maxPoint,
        "template": template,
        "startAt": startAt?.toIso8601String(),
        "minutes": minutes
      };
}

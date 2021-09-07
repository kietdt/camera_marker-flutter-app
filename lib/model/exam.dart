import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/model/config.dart';
import 'package:camera_marker/model/result.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class Exam {
  Exam(
      {this.id,
      this.title,
      this.question,
      this.myClassId,
      this.maxPoint,
      this.templateId,
      this.startAt,
      this.minutes,
      this.answerIds});

  String? id;
  String? title;
  int? question;
  String? myClassId;
  double? maxPoint;
  int? templateId;
  DateTime? startAt;
  int? minutes;
  List<String>? answerIds;
  List<String>? resultIds;
  DateTime? createdAt;
  DateTime? updatedAt;

  int get maxQuestions => 200;

  String get minutesText => "$minutes phút";

  MyClass? get myClass => DataBaseCtr().tbClass.getById(myClassId);

  Template? get template => DataBaseCtr().tbTemplate.getById(templateId);

  List<Answer> get answer => List<Answer>.from(DataBaseCtr()
      .tbAnswer
      .entities
      .where((element) => (answerIds ?? []).contains(element.id)));

  List<Result> get result => List<Result>.from(DataBaseCtr()
      .tbResult
      .entities
      .where((element) => (resultIds ?? []).contains(element.id)));

  static List<int> questionsSelect =
      List<int>.generate(200, (index) => index + 1);

  int correct(Result? result) {
    if (result == null) return -1;

    List<Answer> _temp = answer;
    int index =
        _temp.indexWhere((element) => result.examCode == element.examCode);

    if (index >= 0) {
      return _temp[index].verify(result.value);
    }

    return -1;
  }

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
    this.resultIds = json["resultIds"] != null
        ? List<String>.from(json["resultIds"].map((e) => e))
        : [];
    this.createdAt =
        json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null;
    this.updatedAt =
        json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null;
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
        "answerIds": this.answerIds,
        "resultIds": this.resultIds,
        "createdAt": this.createdAt?.toIso8601String(),
        "updatedAt": this.updatedAt?.toIso8601String(),
      };
}

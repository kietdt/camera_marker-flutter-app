//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com

import 'dart:math';

import 'result.dart';
import 'statistics.dart';

enum AnswerValueEnum { A, B, C, D }

class Answer {
  Answer({this.id, this.examCode, this.value});

  String? id;
  String? examCode;
  List<AnswerValue?>? value;
  DateTime? createdAt;
  DateTime? updatedAt;

  static int codeLength = 3;

  int indexEmpty() {
    int index =
        value?.indexWhere((element) => (element?.valueString ?? "").isEmpty) ??
            -1;
    return index;
  }

  Answer.fromJson(Map json) {
    this.id = json["id"];
    this.examCode = json["examCode"];
    this.value = json["value"] != null
        ? List<AnswerValue>.from(
            json["value"].map((e) => AnswerValue.fromJson(e)))
        : [];
    this.createdAt =
        json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null;
    this.updatedAt =
        json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null;
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "examCode": this.examCode,
        "value": List<Map<String, dynamic>>.from(
            this.value?.map((e) => e?.toJson()) ?? []),
        "createdAt": this.createdAt?.toIso8601String(),
        "updatedAt": this.updatedAt?.toIso8601String()
      };

  //tính số câu đúng
  int verify(List<AnswerValue?>? result) {
    int correct = 0;
    int length = min((result?.length ?? 0), (value?.length ?? 0));

    if (length <= 0) return 0;

    for (int i = 0; i < length; i++) {
      if (match(value?[i], result?[i])) {
        correct++;
      }
    }
    return correct;
  }

  //Kiểm tra hai đáp án giống nhau
  bool match(AnswerValue? first, AnswerValue? second) {
    if (first?.valueEnum?.length != second?.valueEnum?.length) return false;

    int i = 0;

    while (i < (first?.valueEnum?.length ?? 0)) {
      if (!(first?.valueEnum?.contains(second?.valueEnum?[i]) ?? false))
        return false;
      if (!(second?.valueEnum?.contains(first?.valueEnum?[i]) ?? false))
        return false;
      i++;
    }

    return true;
  }

  List<CorrectPercent> correctByQuestion(List<Result> result) {
    List<CorrectPercent> _temp = List.generate(
        value?.length ?? 0, (index) => CorrectPercent(question: index + 1));
    for (int i = 0; i < (value?.length ?? 0); i++) {
      int sum = 0;
      for (int j = 0; j < result.length; j++) {
        if (match(value?[i], result[j].value?[i])) {
          sum++;
        }
      }
      _temp[i].percent = (sum / (max(result.length, 1))) * 100;
    }
    return _temp;
  }

  //model mẫu để test
  //sau này scan được sẽ xóa đi
  static Map<String, dynamic> sample = {
    "examCode": "011",
    "value": [
      {"valueString": "A B"},
      {"valueString": "B C"},
      {"valueString": "C D"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
    ]
  };
}

class AnswerValue {
  AnswerValue({
    this.valueEnum,
  }) {
    this.valueString = getValueString(this.valueEnum);
  }

  factory AnswerValue.empty() => AnswerValue(valueEnum: []);

  String? valueString;
  List<AnswerValueEnum>? valueEnum;

  AnswerValue.fromJson(Map json) {
    this.valueString = json["valueString"];
    this.valueEnum = getValueEnum(this.valueString);
  }

  Map<String, dynamic> toJson() => {
        "valueString": this.valueString,
      };

  void addValueEnum(AnswerValueEnum valueEnum) {
    this.valueEnum?.add(valueEnum);
    this.valueString = getValueString(this.valueEnum);
  }

  void removeValueEnum(int index) {
    this.valueEnum?.removeAt(index);
    this.valueString = getValueString(this.valueEnum);
  }

  String getValueString(List<AnswerValueEnum>? valueEnum) {
    if (valueEnum == null) return "";
    String _temp = "";

    if (existEnum(AnswerValueEnum.A)) {
      _temp += "A ";
    }
    if (existEnum(AnswerValueEnum.B)) {
      _temp += "B ";
    }
    if (existEnum(AnswerValueEnum.C)) {
      _temp += "C ";
    }
    if (existEnum(AnswerValueEnum.D)) {
      _temp += "D ";
    }
    _temp = _temp.trim();
    return _temp;
  }

  bool existEnum(AnswerValueEnum answerValueEnum) {
    int? index = valueEnum?.indexWhere((element) => element == answerValueEnum);

    return (index != null && index >= 0);
  }

  List<AnswerValueEnum>? getValueEnum(String? valueString) {
    if (valueString == null) return null;

    List<AnswerValueEnum>? _temp = [];

    if (valueString.contains("A")) {
      _temp.add(AnswerValueEnum.A);
    }
    if (valueString.contains("B")) {
      _temp.add(AnswerValueEnum.B);
    }
    if (valueString.contains("C")) {
      _temp.add(AnswerValueEnum.C);
    }
    if (valueString.contains("D")) {
      _temp.add(AnswerValueEnum.D);
    }

    return _temp;
  }
}

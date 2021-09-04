enum AnswerValueEnum { A, B, C, D }

class Answer {
  Answer({this.id, this.code, this.value});

  String? id;
  int? code;
  List<AnswerValue?>? value;

  static int codeLength = 3;

  Answer.fromJson(Map json) {
    this.id = json["id"];
    this.code = json["code"];
    this.value = json["value"] != null
        ? List<AnswerValue>.from(
            json["value"].map((e) => AnswerValue.fromJson(e)))
        : [];
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "code": this.code,
        "value": List<Map<String, dynamic>>.from(
            this.value?.map((e) => e?.toJson()) ?? [])
      };

  //model mẫu để test
  //sau này scan được sẽ xóa đi
  static Map<String, dynamic> sample = {
    "code": 122,
    "value": [
      {"valueString": "A"},
      {"valueString": "B"},
      {"valueString": "C"},
      {"valueString": "A"},
      {"valueString": "A"},
      {"valueString": "A"},
    ]
  };
}

class AnswerValue {
  AnswerValue({
    // this.index,
    this.valueEnum,
  }) {
    this.valueString = getValueString(this.valueEnum);
  }

  // int? index;
  String? valueString;
  AnswerValueEnum? valueEnum;

  AnswerValue.fromJson(Map json) {
    // this.index = json["index"];
    this.valueString = json["valueString"];
    this.valueEnum = getValueEnum(this.valueString);
  }

  Map<String, dynamic> toJson() => {
        // "index": this.index,
        "valueString": this.valueString,
      };

  String getValueString(AnswerValueEnum? valueEnum) {
    if (valueEnum == null) return "";
    switch (valueEnum) {
      case AnswerValueEnum.A:
        return "A";
      case AnswerValueEnum.B:
        return "B";
      case AnswerValueEnum.C:
        return "C";
      case AnswerValueEnum.D:
        return "D";
    }
  }

  AnswerValueEnum? getValueEnum(String? valueString) {
    if (valueString == null) return null;
    switch (valueString) {
      case "A":
        return AnswerValueEnum.A;
      case "B":
        return AnswerValueEnum.B;
      case "C":
        return AnswerValueEnum.C;
      case "D":
        return AnswerValueEnum.D;
    }
  }
}

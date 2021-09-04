enum AnswerValueEnum { A, B, C, D }

class Answer {
  Answer({this.id, this.code, this.value});

  String? id;
  String? code;
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
    "code": "011",
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
    // this.index,
    this.valueEnum,
  }) {
    this.valueString = getValueString(this.valueEnum);
  }

  factory AnswerValue.empty() => AnswerValue(valueEnum: []);

  // int? index;
  String? valueString;
  List<AnswerValueEnum>? valueEnum;

  AnswerValue.fromJson(Map json) {
    // this.index = json["index"];
    this.valueString = json["valueString"];
    this.valueEnum = getValueEnum(this.valueString);
  }

  Map<String, dynamic> toJson() => {
        // "index": this.index,
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

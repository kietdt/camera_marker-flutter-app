//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com

class MyClass {
  String? id;
  String? code;
  String? name;
  String? desc;
  DateTime? createdAt;
  DateTime? updatedAt;

  String get titleDisplay => code ?? "";
  
  MyClass(
      {this.id,
      this.code,
      this.name,
      this.desc,
      this.createdAt,
      this.updatedAt});

  MyClass.fromJson(Map json) {
    id = json["id"];
    code = json["code"];
    name = json["name"];
    desc = json["desc"];
    createdAt = json["created_at"] != null
        ? DateTime.parse(json["created_at"]).toLocal()
        : null;
    updatedAt = json["updated_at"] != null
        ? DateTime.parse(json["updated_at"]).toLocal()
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "desc": desc,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String()
    };
  }
}

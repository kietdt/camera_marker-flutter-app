//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com

class ConfigRespo {
  Config? config;
  List<Template>? template;

  ConfigRespo({this.config, this.template});

  ConfigRespo.fromJson(Map<String, dynamic> json) {
    config =
        json['config'] != null ? new Config.fromJson(json['config']) : null;
    if (json['template'] != null) {
      template = [];
      json['template'].forEach((v) {
        template?.add(new Template.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.config != null) {
      data['config'] = this.config?.toJson();
    }
    if (this.template != null) {
      data['template'] = this.template?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Config {
  String? version;

  Config({this.version});

  Config.fromJson(Map<String, dynamic> json) {
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    return data;
  }
}

enum TemplateType { Multi, Single }

class Template {
  int? id;
  String? title;
  String? desc;
  int? question;
  String? type;
  String? typeDecs;
  String? thumbnail;
  String? originalImage;
  String? downloadLink;
  String? createAt;
  String? updateAt;
  TemplateType? templateType;
  bool? visible;
  int? maxAnswer;

  bool get isMulti => templateType == TemplateType.Multi;

  String get titleDisplay => (title ?? "") + " - " + (typeDecs ?? "");

  List<int> get questionsSelect =>
      List<int>.generate(question ?? 0, (index) => index + 1);

  Template(
      {this.id,
      this.title,
      this.desc,
      this.question,
      this.type,
      this.thumbnail,
      this.originalImage,
      this.createAt,
      this.visible,
      this.updateAt}) {
    this.templateType = getType(this.type);
  }

  Template.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    question = json['question'];
    type = json['type'];
    this.templateType = getType(this.type);
    typeDecs = json['type_desc'];
    thumbnail = json['thumbnail'];
    originalImage = json['original_image'];
    downloadLink = json['download_link'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    visible = json['visible'];
    maxAnswer = json['max_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['question'] = this.question;
    data['type'] = this.type;
    data['type_desc'] = this.typeDecs;
    data['thumbnail'] = this.thumbnail;
    data['original_image'] = this.originalImage;
    data['download_link'] = this.downloadLink;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    data['visible'] = this.visible;
    data['max_answer'] = this.maxAnswer;
    return data;
  }

  TemplateType getType(String? type) {
    switch (type) {
      case "multi_choice":
        return TemplateType.Multi;
      case "single_choice":
        return TemplateType.Single;
    }
    return TemplateType.Single;
  }
}

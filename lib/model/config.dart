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

class Template {
  int? id;
  String? title;
  String? desc;
  int? question;
  List<String>? type;
  String? thumbnail;
  String? originalImage;
  String? createAt;
  String? updateAt;

  Template(
      {this.id,
      this.title,
      this.desc,
      this.question,
      this.type,
      this.thumbnail,
      this.originalImage,
      this.createAt,
      this.updateAt});

  Template.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    question = json['question'];
    type = json['type'].cast<String>();
    thumbnail = json['thumbnail'];
    originalImage = json['original_image'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['question'] = this.question;
    data['type'] = this.type;
    data['thumbnail'] = this.thumbnail;
    data['original_image'] = this.originalImage;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    return data;
  }
}
import 'package:camera_marker/database/base_table.dart';
import 'package:camera_marker/model/config.dart';

import 'base_path.dart';

class TbTemplate extends BaseTable<Template> {
  @override
  String get path => BasePath.TEMPLATE;

  @override
  List<Template> fromJson(List json) {
    List<Template> temp =
        List<Template>.from(json.map((e) => (Template.fromJson(e))));
    return temp;
  }

  @override
  List<Map<String, dynamic>> toJson(List<Template> entries) {
    List<Map<String, dynamic>> temp =
        List<Map<String, dynamic>>.from(entities.map((e) => e.toJson()));
    return temp;
  }

  Template? getById(int? id) {
    int index = entities.indexWhere((element) => element.id == id);
    if (index >= 0) {
      return entities[index];
    }
    return null;
  }
}

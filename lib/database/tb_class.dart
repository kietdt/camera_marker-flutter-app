import 'package:camera_marker/database/base_table.dart';
import 'package:camera_marker/model/class.dart';

import 'base_path.dart';

class TbClass extends BaseTable<MyClass> {
  @override
  String get path => BasePath.CLASS;

  @override
  List<MyClass> fromJson(List jsons) {
    List<MyClass> temp =
        List<MyClass>.from(jsons.map((e) => MyClass.fromJson(e)));
    return temp;
  }

  @override
  List<Map<String, dynamic>> toJson(List<MyClass> entries) {
    List<Map<String, dynamic>> temp =
        List<Map<String, dynamic>>.from(entities.map((e) => e.toJson()));
    return temp;
  }

  Future<void> addClass(MyClass _class) async {
    _class.id = newId();
    _class.createdAt = DateTime.now();
    _class.updatedAt = DateTime.now();
    await add(_class);
  }

  Future<void> updateClass(MyClass _class) async {
    _class.updatedAt = DateTime.now();
    int index = entities.indexWhere((element) => element.id == _class.id);
    await set(index);
  }

  Future<void> deleteClass(MyClass _class) async {
    int index = entities.indexWhere((element) => element.id == _class.id);
    await delete(index);
  }
}

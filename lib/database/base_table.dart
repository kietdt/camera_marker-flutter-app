import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

abstract class BaseTable<T> {
  late String path;

  late List<T> _entities;
  List<T> get entities => _entities;
  set entities(List<T> value) => this._entities = value;

  List<T> fromJson(List jsons);
  List<Map<String, dynamic>> toJson(List<T> entries);

  Future<void> loadTable() async {
    var _pref = await SharedPreferences.getInstance();
    List? _jsons = json.decode(_pref.getString(path) ?? "[]");
    if (_jsons is List) {
      entities = fromJson(_jsons);
    } else {
      entities = [];
    }
  }

  Future<void> storeTable() async {
    var _pref = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> _jsons = toJson(entities);
    _pref.setString(path, json.encode(_jsons));
  }

  Future add(T entity) async {
    entities.add(entity);
    await storeTable();
  }

  Future addList(List<T> entitiesTmp) async {
    entities.addAll(entitiesTmp);
    await storeTable();
  }

  Future<bool> set(int index, T item) async {
    if (index >= 0) {
      entities[index] = item;
      await storeTable();
      return true;
    }
    return false;
  }

  Future<bool> setList(List<T> entitiesTmp) async {
    entities = entitiesTmp;
    await storeTable();
    return false;
  }

  Future<bool> delete(int index) async {
    if (index >= 0) {
      entities.removeAt(index);
      await storeTable();
      return true;
    }
    return false;
  }

  String newId() {
    return Uuid().v4();
  }
}

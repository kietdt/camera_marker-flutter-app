import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseTable<T> {
  late String path;

  late List<T> _entities;
  List<T> get entities => _entities;
  set entities(List<T> value) => this._entities = value;

  List<T> fromJson(List<Map<String, dynamic>> jsons);
  List<Map<String, dynamic>> toJson(List<T> entries);

  Future<void> loadTable() async {
    var _pref = await SharedPreferences.getInstance();
    List<dynamic> _jsons = json.decode(_pref.getString(path) ?? "[]");
    if (_jsons is List<Map<String, dynamic>>) {
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

  Future<bool> set(T entity) async {
    int index = getIndex(entity);
    if (index >= 0) {
      entities[index] = entity;
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

  Future<bool> delete(T entity) async {
    int index = getIndex(entity);
    if (index >= 0) {
      entities.removeAt(index);
      await storeTable();
      return true;
    }
    return false;
  }

  int getIndex(T entity) {
    int index = entities.indexWhere((element) => element == entity);
    return index;
  }
}

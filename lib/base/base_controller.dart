import 'package:flutter/material.dart';
import 'package:get/get.dart';

//created by Kietdt 28/07/2021
abstract class BaseController<S extends State> {
  S? _state;

  S? get state => _state;

  //UI
  RxBool _loading = false.obs;
  RxBool get loading => _loading;

  BaseController(S state) {
    this._state = state;
  }

  void showLoading() {
    _loading.value = true;
  }

  void hideLoading() {
    _loading.value = false;
  }

  void onDispose() {}

  //defaul methods
  void hideKeyboard() => _state != null
      ? FocusScope.of(_state!.context).requestFocus(FocusNode())
      : null;
}

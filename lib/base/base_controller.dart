import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseController<S extends State> extends GetxController {
  State? _state;

  State? get state => _state;

  //UI
  RxBool _loading = false.obs;
  RxBool get loading => _loading;

  BaseController(State state) {
    this._state = state;
  }

  void showLoading() {
    _loading = true.obs;
  }

  void hideLoading() {
    _loading = false.obs;
  }

  void onDispose() {}

  //defaul methods
  void hideKeyboard() => _state != null
      ? FocusScope.of(_state!.context).requestFocus(FocusNode())
      : null;
}

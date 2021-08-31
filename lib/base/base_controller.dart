import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//created by Kietdt 28/07/2021
//contact email: dotuankiet1403@gmail.com
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

  void bottomSnackBar(String title, String message) {
    Get.snackbar(title, message,
        colorText: ResourceManager().color.white,
        backgroundColor: ResourceManager().color.primary,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        duration: Duration(milliseconds: 1500));
  }

  void topSnackBar(String title, String message) {
    Get.snackbar(title, message,
        colorText: ResourceManager().color.black,
        backgroundColor: ResourceManager().color.white,
        boxShadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          )
        ],
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        duration: Duration(milliseconds: 1500));
  }
}

import 'package:get/get.dart';

// chưa sử dụng được
class BaseObsever<T> {
  var _value;

  BaseObsever(T value) {
    this._value = value.obs;
  }

  T? get value => this._value.value;

  set value(T? value) => this._value = value.obs;
}

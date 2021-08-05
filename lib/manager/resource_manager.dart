import 'package:camera_marker/resource/color.dart';
import 'package:camera_marker/resource/text_style.dart';

class ResourceManager {
  static ResourceManager? _internal;
  ResourceManager._();

  BaseColor? color;
  BaseTextStyle? text;

  factory ResourceManager() {
    if (_internal == null) _internal = ResourceManager._();
    return _internal!;
  }

  void init() {
    color = BaseColor();
    text = BaseTextStyle();
  }
}

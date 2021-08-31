import 'package:camera_marker/resource/color.dart';
import 'package:camera_marker/resource/text_style.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class ResourceManager {
  static ResourceManager? _internal;
  ResourceManager._();

  late BaseColor color;
  late BaseTextStyle text;

  String appName = "For Teacher";

  factory ResourceManager() {
    if (_internal == null) _internal = ResourceManager._();
    return _internal!;
  }

  void init() {
    color = BaseColor();
    text = BaseTextStyle();
  }
}

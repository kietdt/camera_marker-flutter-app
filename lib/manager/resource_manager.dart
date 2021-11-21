import 'dart:io';

import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/resource/color.dart';
import 'package:camera_marker/resource/text_style.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class ResourceManager {
  static ResourceManager? _internal;
  ResourceManager._();

  late BaseColor color;
  late BaseTextStyle text;
  late PackageInfo deviceVersion;

  String appName = "MMCQ";

  String get linkUpdate =>
      "https://play.google.com/store/apps/details?id=uit.kltn.cttt2015.camera_marker";

  factory ResourceManager() {
    if (_internal == null) _internal = ResourceManager._();
    return _internal!;
  }

  Future<void> init() async {
    color = BaseColor();
    text = BaseTextStyle();
    deviceVersion = await PackageInfo.fromPlatform();
  }
}

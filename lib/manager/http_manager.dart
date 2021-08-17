import 'package:camera_marker/base/base_http.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class HttpManager {
  HttpManager._();
  static HttpManager? _singleton;

  factory HttpManager() {
    if (_singleton == null) _singleton = HttpManager._();
    return _singleton!;
  }

  BaseHttp baseHttp = BaseHttp();

  String path = "camera_marker_config";

  Future<Map<String, dynamic>?> getConfig() async {
    var respo = await baseHttp.get(path);
    return respo;
  }
}

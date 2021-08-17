import 'package:dio/dio.dart';

//create by kietdt 18/08/2021
class BaseHttp {
  static const String API_KEY = "fd9697ec-d23f-4b2b-b734-16bda28fc794";
  static const String BASE_API = "https://json.psty.io/api_v1/stores/";

  static const Map<String, String> HEADER = {"Api-Key": API_KEY};

  static BaseOptions _baseOption = BaseOptions(
      baseUrl: BASE_API, headers: HEADER, contentType: "application/json");

  Future<Map<String, dynamic>?> get(String path,
      {Map<String, dynamic>? params}) async {
    var response = await Dio(_baseOption)
        .get<Map<String, dynamic>>(path, queryParameters: params);
    return wrapResponse(response);
  }

  Map<String, dynamic>? wrapResponse(Response response) {
    return response.data;
  }
}

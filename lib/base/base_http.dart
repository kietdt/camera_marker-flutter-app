import 'package:dio/dio.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class BaseHttp {
  static const String API_KEY = "fd9697ec-d23f-4b2b-b734-16bda28fc794";
  static const String BASE_API = "https://json.psty.io/api_v1/stores/";

  static const Map<String, String> HEADER = {"Api-Key": API_KEY};

  static BaseOptions _baseOption = BaseOptions(
      baseUrl: BASE_API, headers: HEADER, contentType: "application/json");

  Future<Map<String, dynamic>?> get(String path,
      {Map<String, dynamic>? params}) async {
    Dio dio = Dio(_baseOption);
    dio
      ..interceptors.add(LogInterceptor(
          responseBody: true,
          request: true,
          requestBody: true,
          requestHeader: true,
          responseHeader: true));
    var response = await dio
        .get<Map<String, dynamic>>(path, queryParameters: params)
        .catchError((e) {
      if (e is DioError) {
        return Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: path),
            data: {"data": e.error});
      }
    });
    return wrapResponse(response);
  }

  Map<String, dynamic>? wrapResponse(Response response) {
    return response.data;
  }
}

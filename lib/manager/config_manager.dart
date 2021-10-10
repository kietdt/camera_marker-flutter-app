import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:camera_marker/base/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//không sử dụng class này nữa, nhưng vẫn lưu lại vì có code cấu trúc download file, có thể tương lại sẽ cần sử dụng
//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class ConfigManager {
  // final rootConfig = BasePath.ROOT_CONFIG;

  final String configLink = "";
  final String configFileName = "config.json";

  static const String configPort =
      "download_config_port"; //tên của port nhận thông tin khi của task download file config

  String? rootPath; //đường dẫn lưu file config
  String get filePath =>
      rootPath! + "$configFileName"; //đường dẫn lưu file config
  ReceivePort _port = ReceivePort();
  String? taskId; // id của request download
  Completer? completer;

  Future<void> init() async {
    completer = Completer();

    try {
      await FlutterDownloader.initialize(debug: kDebugMode);
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(_downloadCallback);
    } catch (e) {
      print(e);
    }

    await requestPermission();
    await getConfig();
    await completer!.future;
  }

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      try {
        while (!status.isGranted) {
          status = await Permission.storage.request();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getConfig() async {
    String localPath = await Utils.localPath();
    await _prepareSaveDir(localPath);
    if (rootPath != null) {
      _requestDownload();
    }
  }

  Future<void> _prepareSaveDir(String localPath) async {
    //Khởi tạo thư mục để lưu file config, nếu chưa có thì tạo mới bằng lệnh create
    this.rootPath = localPath + Platform.pathSeparator;
    final savedDir = Directory(this.rootPath!);

    try {
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _requestDownload() async {
    //chỉ download 1 task duy nhất nên không cần sử dụng taskId
    //sau này muốn show progress thì config thêm
    //chi tiết xem ở https://pub.dev/packages/flutter_downloader/example
    taskId = await FlutterDownloader.enqueue(
        url: configLink,
        savedDir: rootPath!,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _bindBackgroundIsolate() async {
    bool isSuccess =
        IsolateNameServer.registerPortWithName(_port.sendPort, configPort);
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2]; //progress tải link download

      if (taskId != null && taskId == id) {
        print("downloading=======config=======progress:$progress");
        if (status == DownloadTaskStatus.complete) {
          //xóa task download
          _deleteTask();
          _unbindBackgroundIsolate();
          //check version mới nhất, nếu có thì show dialog update
          //lưu mẫu template vào database
          print("downloaded=======config=======path:$filePath");
          await _getJsonCongig();
          completer!.complete();
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(configPort);
  }

  static void _downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName(configPort)!;
    send.send([id, status, progress]);
  }

  void _deleteTask() async {
    if (taskId != null) {
      await FlutterDownloader.remove(
          taskId: taskId!, shouldDeleteContent: true);
    }
  }

  Future<void> _getJsonCongig() async {
    File file = File(filePath);
    var _jsonString = await file.readAsString();
    Map<String, dynamic> _json = json.decode(_jsonString);
  }
}

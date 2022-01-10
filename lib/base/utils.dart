import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class Utils {
  static const String DMY = "dd/MM/yyyy";
  static const String DMYHM = "dd/MM/yyyy HH:mm";
  static const String HM = "HH:mm";

  static void statusPrint(String title, String content) {
    int maxLength = 50;
    int perLine = 255;

    if (content.length > maxLength || title.length > maxLength) {
      print("$title:$content");
    } else {
      int horiLeft = (maxLength - title.length) ~/ 2;
      int horiRight = maxLength - horiLeft - 2 - title.length;

      String top = strFromList(List.generate(maxLength, (index) => "="));
      String bot = strFromList(List.generate(maxLength, (index) => "="));
      String left = strFromList(
          List.generate(horiLeft, (index) => index == 0 ? "||" : " "));
      String right = strFromList(List.generate(
          horiRight, (index) => index == (horiRight - 1) ? "||" : " "));

      print("$top\n");
      if (maxLength % perLine > 0) {
        int length = maxLength % perLine;
        List.generate(length, (index) => {});
        print("$left$title$right\n");
      }
      print("$bot");

      horiLeft = (maxLength - content.length) ~/ 2;
      horiRight = maxLength - horiLeft - 2 - content.length;

      top = strFromList(List.generate(maxLength, (index) => "="));
      bot = strFromList(List.generate(maxLength, (index) => "="));
      left = strFromList(
          List.generate(horiLeft, (index) => index == 0 ? "||" : " "));
      right = strFromList(List.generate(
          horiRight, (index) => index == (horiRight - 1) ? "||" : " "));

      print("$left$content$right\n");
      print("$bot");
    }
  }

  static String dateToStr(DateTime? dateTime, {String? pattern}) {
    if (dateTime == null) return "";
    String temp = DateFormat(pattern ?? DMY).format(dateTime);
    return temp;
  }

  static String upperAllFirst(String? text) {
    if (text == null || text.isEmpty) return "";
    List<String> list = text.split(" ");
    list = List.generate(list.length, (index) {
      if (list[index].length > 0) {
        String first = list[index][0];
        list[index] = list[index].substring(1);
        list[index] = first.toUpperCase() + list[index];
        return list[index];
      }
      return "";
    });
    return list.join(" ");
  }

  static String strFromList(List<String> list) {
    String temp = "";
    List.generate(list.length, (index) => temp += list[index]);
    return temp;
  }

  static Future<String> localPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  static Future<File?> copyFile(String name,
      {String? rootPath, File? file}) async {
    rootPath = (rootPath ?? await localPath()) + Platform.pathSeparator;
    String newPath = rootPath + name;
    try {
      File newFile = File(newPath);
      await newFile.create(recursive: true);
      file?.copy(newPath);
      print("copy=====SUCCESS===${file?.path}===TO===>>>$newPath");
    } catch (e) {
      try {
        File newFile = File(newPath);
        await newFile.create(recursive: true);
        file?.copy(newPath);
        print("copy=====SUCCESS===${file?.path}===TO===>>>$newPath");
      } catch (e) {
        print(e);
      }
    }
    return file;
  }

  static Future<void> deletefile(String path) async {
    File file = File(path);
    String fileName = path.split("/").last;
    print("$fileName=======EXESIT===>${await file.exists()}");
    try {
      await file.delete();
      print("delete====SUCCESS===>$path");
    } catch (e) {
      try {
        Directory dir = Directory(path);
        dir.deleteSync(recursive: true);
        print("delete==directory==SUCCESS===>$path");
      } catch (e) {
        print(e);
      }
      print(e);
    }
    print("$fileName=======EXESIT===>${await file.exists()}");
  }
}

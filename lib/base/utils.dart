import 'package:intl/intl.dart';

class Utils {
  static const String DMY = "dd/MM/yyyy";
  static const String DMYHM = "dd/MM/yyyy HH:mm";
  static const String HM = "HH:mm";

  static void statusPrint(String action, String what,
      {bool success = true, bool? loadig, String? customMes}) {
    String status = success ? "SUCCESS" : "FAILED";
    if (loadig != null) {
      status = "LOADING";
    }
    print(
        "$action========$what=========>${status + " <=> " + (customMes ?? "")}");
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
      String first = list[index][0];
      list[index] = list[index].substring(1);
      list[index] = first.toUpperCase() + list[index];
      return list[index];
    });
    return list.join(" ");
  }
}

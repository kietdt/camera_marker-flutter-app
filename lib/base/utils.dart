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
}

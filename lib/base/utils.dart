class Utils {
  static void statusPrint(String action, String what,
      {bool success = true, bool? loadig, String? customMes}) {
    String status = success ? "SUCCESS" : "FAILED";
    if (loadig != null) {
      status = "LOADING";
    }
    print(
        "$action========$what=========>${status + " <=> " + (customMes ?? "")}");
  }
}

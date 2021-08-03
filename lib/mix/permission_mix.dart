import 'package:permission_handler/permission_handler.dart';

mixin PermissionMix {
  Future<void> requestCameraPermission() async {
    //Request permission for camera
    PermissionStatus status = await Permission.camera.status;
    while (!status.isGranted) status = await Permission.camera.request();
  }
}

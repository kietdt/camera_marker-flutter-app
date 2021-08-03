import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Basic Camera widget, no functionality here.
///
/// The widget requires [CameraController] to load the actual camera on screen.
class CameraScreenWidget extends StatelessWidget {
  final CameraController? controller;

  const CameraScreenWidget({
    Key? key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return SizedBox();
    } else {
      return CameraPreview(controller!);
      // return AspectRatio(
      //     aspectRatio: widget.controller!.value.aspectRatio,
      //     child: CameraPreview(widget.controller!));
    }
  }
}

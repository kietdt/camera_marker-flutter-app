import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomImageView extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final Alignment? alignment;
  final double? loadingSize;

  CustomImageView(this.url,
      {this.width,
      this.height,
      this.color,
      this.fit,
      this.alignment,
      this.loadingSize});

  bool get isNetWork => url.startsWith("http");

  @override
  Widget build(BuildContext context) {
    return isNetWork
        ? Image.network(
            url,
            key: ValueKey(url),
            width: width,
            height: height,
            color: color,
            fit: fit ?? BoxFit.contain,
            alignment: alignment ?? Alignment.topCenter,
            loadingBuilder: buildLoading,
          )
        : Image.asset(
            url,
            width: height,
            height: height,
            color: color,
            fit: fit ?? BoxFit.contain,
            alignment: alignment ?? Alignment.topCenter,
          );
  }

  Widget buildLoading(
      BuildContext ctx, Widget widget, ImageChunkEvent? imageChunkEvent) {
    if (imageChunkEvent == null) return widget;
    return Container(
        width: loadingSize,
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.1),
        child: SpinKitWanderingCubes(
            size: (loadingSize ?? width ?? 200) / 5,
            color: ResourceManager().color!.primary));
  }
}

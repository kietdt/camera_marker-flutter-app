import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

class EmptyPageView extends StatelessWidget {
  final String? asset;
  final String? message;

  const EmptyPageView({Key? key, this.asset, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      CustomImageView(asset ?? "lib/asset/ic_empty.png",
          width: 100, height: 100, color: ResourceManager().color.primary),
      SizedBox(height: 10),
      Text(message ?? "",
          style: ResourceManager()
              .text
              .normalStyle
              .copyWith(color: ResourceManager().color.primary, fontSize: 16))
    ]));
  }
}

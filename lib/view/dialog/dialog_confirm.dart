import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/view/child/rect_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com

class DialogConfirm extends StatelessWidget {
  final Function()? onLeft;
  final Function()? onRight;
  final String? title;
  final String? message;
  final String? leftTitle;
  final String? rightTitle;
  final bool? hasImage;
  final String? fact;
  final Color? leftColor;

  static show(
      {Function()? onLeft,
      Function()? onRight,
      String? title,
      String? message,
      String? leftTitle,
      bool? hasImage,
      String? fact,
      bool? barrierDismissible,
      Color? leftColor,
      String? rightTitle}) async {
    return Get.dialog(
        DialogConfirm(
            message: message,
            onLeft: onLeft,
            onRight: onRight,
            title: title,
            leftTitle: leftTitle,
            rightTitle: rightTitle,
            fact: fact,
            leftColor: leftColor,
            hasImage: hasImage),
        barrierDismissible: barrierDismissible ?? false);
  }

  const DialogConfirm({
    Key? key,
    this.onLeft,
    this.onRight,
    this.title,
    this.leftTitle,
    this.rightTitle,
    this.hasImage,
    this.fact,
    this.leftColor,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
            color: ResourceManager().color.white,
            borderRadius: BorderRadius.all(Radius.circular(7))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 14),
            _image(),
            SizedBox(height: 7),
            Text(
              title ?? "Xác nhận",
              style: ResourceManager().text.boldStyle.copyWith(
                  color: ResourceManager().color.primary, fontSize: 20),
            ),
            SizedBox(height: 7),
            Visibility(
                visible: message != null,
                child: Text(
                  message ?? "",
                  textAlign: TextAlign.center,
                  style: ResourceManager().text.normalStyle.copyWith(
                      color: ResourceManager().color.des, fontSize: 13),
                )),
            Visibility(
                visible: fact != null,
                child: Column(
                  children: [
                    SizedBox(height: 7),
                    Text(
                      fact ?? "",
                      textAlign: TextAlign.center,
                      style: ResourceManager().text.normalStyle.copyWith(
                          color: ResourceManager().color.error, fontSize: 13),
                    ),
                  ],
                )),
            SizedBox(height: 14),
            _bottom(),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return Visibility(
      visible: hasImage ?? true,
      child: Container(
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(width: 3, color: ResourceManager().color.primary)),
        child: CustomImageView(
          "lib/asset/ic_confirm.png",
          width: 50,
          height: 50,
          color: ResourceManager().color.primary,
        ),
      ),
    );
  }

  Widget _bottom() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: RectButton(
                borderColor: leftColor ?? ResourceManager().color.des,
                textColor: leftColor ?? ResourceManager().color.des,
                color: ResourceManager().color.white,
                title: leftTitle ?? "Hủy",
                onTap: () {
                  Get.back();
                  if (onLeft != null) onLeft!();
                },
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: RectButton(
                title: rightTitle,
                onTap: () {
                  Get.back();
                  if (onRight != null) onRight!();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

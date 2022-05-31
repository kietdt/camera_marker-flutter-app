import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/view/child/rect_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class DialogNoti extends StatelessWidget {
  final String? title;
  final String? message;
  final bool? hasImage;
  final String? fact;
  final String? image;
  final Color? imageColor;
  final Widget? child;
  final EdgeInsets? imagePadding;
  final double? imageSize;
  final String? continuteMessage;
  final Widget? childUnderMessage;
  final double messageFontSize;

  static show(
      {String? title,
      String? message,
      bool? hasImage = false,
      String? fact,
      bool? barrierDismissible,
      Color? imageColor,
      String? image,
      Widget? child,
      EdgeInsets? imagePadding,
      double? imageSize,
      String? continuteMessage,
      Widget? childUnderMessage,
      double messageFontSize = 20}) async {
    return Get.dialog(
        DialogNoti(
          message: message,
          title: title,
          fact: fact,
          hasImage: hasImage,
          imageColor: imageColor,
          child: child,
          image: image,
          imagePadding: imagePadding,
          continuteMessage: continuteMessage,
          imageSize: imageSize,
          childUnderMessage: childUnderMessage,
          messageFontSize: messageFontSize,
        ),
        barrierDismissible: barrierDismissible ?? false);
  }

  const DialogNoti({
    Key? key,
    this.title,
    this.hasImage,
    this.fact,
    this.imageColor,
    this.image,
    this.child,
    this.imagePadding,
    this.imageSize,
    this.continuteMessage,
    required this.message,
    this.childUnderMessage,
    this.messageFontSize = 20,
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
              title ?? "Thông báo",
              style: ResourceManager().text.boldStyle.copyWith(
                  color: ResourceManager().color.primary, fontSize: 25),
            ),
            SizedBox(height: 15),
            if (child != null) ...[child!],
            Visibility(
                visible: message != null,
                child: Text(
                  message ?? "",
                  textAlign: TextAlign.center,
                  style: ResourceManager().text.normalStyle.copyWith(
                      color: ResourceManager().color.black,
                      fontSize: messageFontSize),
                )),
            if (childUnderMessage != null) ...[childUnderMessage!],
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
            SizedBox(height: 20),
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
            border: Border.all(
                width: 3,
                color: imageColor ?? ResourceManager().color.primary)),
        child: Padding(
          padding: imagePadding ?? EdgeInsets.all(7),
          child: CustomImageView(
            image ?? "lib/asset/ic_confirm.png",
            width: imageSize ?? 50,
            height: imageSize ?? 50,
            color: imageColor ?? ResourceManager().color.primary,
          ),
        ),
      ),
    );
  }

  Widget _bottom() {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: RectButton(
        borderColor: ResourceManager().color.primary,
        textColor: ResourceManager().color.primary,
        color: ResourceManager().color.white,
        title: continuteMessage ?? "Tiếp tục",
        onTap: () {
          Get.back(result: "true");
        },
      ),
    );
  }
}

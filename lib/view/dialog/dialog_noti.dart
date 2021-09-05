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

  static show({
    String? title,
    String? message,
    bool? hasImage = false,
    String? fact,
    bool? barrierDismissible,
    Color? imageColor,
    String? image,
  }) async {
    return Get.dialog(
        DialogNoti(
            message: message,
            title: title,
            fact: fact,
            hasImage: hasImage,
            imageColor: imageColor,
            image: image),
        barrierDismissible: barrierDismissible ?? false);
  }

  const DialogNoti({
    Key? key,
    this.title,
    this.hasImage,
    this.fact,
    this.imageColor,
    this.image,
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
              title ?? "Thông báo",
              style: ResourceManager().text.boldStyle.copyWith(
                  color: ResourceManager().color.primary, fontSize: 25),
            ),
            SizedBox(height: 15),
            Visibility(
                visible: message != null,
                child: Text(
                  message ?? "",
                  textAlign: TextAlign.center,
                  style: ResourceManager().text.normalStyle.copyWith(
                      color: ResourceManager().color.black, fontSize: 20),
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
        child: CustomImageView(
          image ?? "lib/asset/ic_confirm.png",
          width: 50,
          height: 50,
          color: imageColor ?? ResourceManager().color.primary,
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
        title: "Tiếp tục",
        onTap: () {
          Get.back();
        },
      ),
    );
  }
}

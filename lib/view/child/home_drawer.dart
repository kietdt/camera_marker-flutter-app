import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/mix/clear_mix.dart';
import 'package:camera_marker/view/child/rect_button.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget with ClearMix {
  HomeDrawer(this.screen, this.onClearSuccess);

  late final Size screen;

  final Function() onClearSuccess;

  double get width => screen.width * 0.85;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: ResourceManager().color.card,
      child: Column(
        children: [
          SizedBox(height: 75),
          _logo(),
          SizedBox(height: 50),
          _team(),
          Spacer(),
          _clearData(),
          SizedBox(height: 50),
          _version()
        ],
      ),
    );
  }

  Widget _logo() {
    return Container(
      width: 50,
      height: 50,
      child: CustomImageView("lib/asset/ic_app.png"),
    );
  }

  Widget _team() {
    return Column(
      children: [
        Text(
          "Nhóm Phát triển".toUpperCase(),
          style: ResourceManager()
              .text
              .boldStyle
              .copyWith(color: ResourceManager().color.primary, fontSize: 20),
        ),
        SizedBox(height: 7),
        Text(
          "Đỗ Tuấn Kiệt".toUpperCase(),
          style: ResourceManager()
              .text
              .boldStyle
              .copyWith(color: ResourceManager().color.primary),
        ),
        SizedBox(height: 7),
        Text(
          "Mai Thanh Bình".toUpperCase(),
          style: ResourceManager()
              .text
              .boldStyle
              .copyWith(color: ResourceManager().color.primary),
        ),
        SizedBox(height: 7),
        Text(
          "Nguyễn Thanh Bình".toUpperCase(),
          style: ResourceManager()
              .text
              .boldStyle
              .copyWith(color: ResourceManager().color.primary),
        ),
      ],
    );
  }

  Widget _version() {
    return Container(
      padding: EdgeInsets.all(15),
      color: ResourceManager().color.primary,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Phiên bản",
                style: ResourceManager()
                    .text
                    .boldStyle
                    .copyWith(color: ResourceManager().color.white),
              ),
              Text(
                ResourceManager().deviceVersion.version,
                style: ResourceManager()
                    .text
                    .boldStyle
                    .copyWith(color: ResourceManager().color.white),
              ),
            ],
          ),
          SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bản dựng",
                style: ResourceManager()
                    .text
                    .boldStyle
                    .copyWith(color: ResourceManager().color.white),
              ),
              Text(
                ResourceManager().deviceVersion.buildNumber,
                style: ResourceManager()
                    .text
                    .boldStyle
                    .copyWith(color: ResourceManager().color.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _clearData() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: ResourceManager().color.primary.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 1), // changes position of shadow
        )
      ]),
      margin: EdgeInsets.symmetric(horizontal: screen.width * 0.1),
      child: RectButton(
        title: "Xóa toàn bộ dữ liệu",
        onTap: () => onTap(onClearSuccess),
      ),
    );
  }
}

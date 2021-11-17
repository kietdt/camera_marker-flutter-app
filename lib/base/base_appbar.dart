import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class BaseAppBar {
  BaseAppBar(
      {this.back = true,
      this.leading,
      this.title,
      this.text,
      this.action,
      this.centerTitle = true,
      this.backgroundColor,
      this.textColor});

  final bool? back;
  final Widget? leading;
  final Widget? title;
  final String? text;
  final List<Widget>? action;
  final bool? centerTitle;
  final Color? backgroundColor;
  final Color? textColor;

  static double height = kToolbarHeight;

  PreferredSizeWidget toAppBar() {
    return AppBar(
      backgroundColor: backgroundColor ?? ResourceManager().color.primary,
      title: (text != null)
          ? Text(Utils.upperAllFirst(text ?? ""),
              style: ResourceManager()
                  .text
                  .boldStyle
                  .copyWith(color: textColor ?? Colors.white))
          : title,
      centerTitle: centerTitle,
      leading: back! ? buildBack() : leading,
      actions: action,
    );
  }

  Widget buildBack() {
    return InkWell(onTap: Get.back, child: Icon(Icons.arrow_back));
  }
}

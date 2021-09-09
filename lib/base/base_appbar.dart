import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class BaseAppBar {
  BaseAppBar(
      {this.back,
      this.leading,
      this.title,
      this.text,
      this.action,
      this.centerTitle = true});

  final bool? back;
  final Widget? leading;
  final Widget? title;
  final String? text;
  final List<Widget>? action;
  final bool? centerTitle;

  static double height = kToolbarHeight;

  PreferredSizeWidget toAppBar() {
    return AppBar(
      backgroundColor: ResourceManager().color.primary,
      title: (text != null)
          ? Text(Utils.upperAllFirst(text ?? ""),
              style: ResourceManager().text.boldStyle)
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

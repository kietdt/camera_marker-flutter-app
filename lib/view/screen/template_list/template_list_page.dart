import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'template_list_crt.dart';

class TemplateList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TemplateListState();
  }
}

class TemplateListState extends BaseScaffold<TemplateList, TemplateListCtr> {
  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(back: true, text: "Mẫu đề thi").toAppBar();
  }

  @override
  TemplateListCtr initController() {
    return TemplateListCtr(this);
  }

  @override
  Widget body() {
    return Obx(() => Padding(
          padding: EdgeInsets.symmetric(horizontal: controller.mainPadding),
          child: ListView.builder(
              itemCount: controller.templates.length,
              itemBuilder: (ctx, index) => _item(controller.templates[index])),
        ));
  }

  Widget _item(Template template) {
    double imWidth = 60;
    double imHeight = 90;

    return InkWell(
      onTap: () => controller.onItemPressed(template),
      child: Container(
          margin: EdgeInsets.only(top: controller.mainPadding),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 1), // changes position of shadow
                )
              ],
              color: ResourceManager().color.white,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: IntrinsicHeight(
            child: Row(children: [
              Container(
                  width: imWidth,
                  height: imHeight,
                  child: CustomImageView(
                    template.thumbnail ?? "",
                    width: imWidth,
                    height: imHeight,
                  )),
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(template.title ?? "",
                        style: ResourceManager()
                            .text
                            .boldStyle
                            .copyWith(fontSize: 25)),
                    SizedBox(height: 10),
                    Text((template.desc ?? ""),
                        style: ResourceManager().text.normalStyle)
                  ])),
              next()
            ]),
          )),
    );
  }

  Widget next() {
    return Container(
        child: Icon(Icons.navigate_next,
            color: ResourceManager().color.black, size: 25));
  }
}

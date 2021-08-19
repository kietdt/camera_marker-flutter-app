import 'package:camera_marker/base/base_activity.dart';
import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/config.dart';
import 'package:flutter/material.dart';

import 'template_detail_ctr.dart';

class TemplateDetailPayload {
  final Template? template;

  TemplateDetailPayload(this.template);
}

class TemplateDetail extends StatefulWidget {
  final TemplateDetailPayload? payload;

  const TemplateDetail({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TemplateDetailState();
  }
}

class TemplateDetailState
    extends BaseActivity<TemplateDetail, TemplateDetailCtr> {
  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(
        back: true,
        text: widget.payload?.template?.title ?? "Mẫu đề thi",
        action: [_share()]).toAppBar();
  }

  @override
  TemplateDetailCtr initController() {
    return TemplateDetailCtr(this);
  }

  @override
  Widget body() {
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(controller!.mainPadding),
            child: Column(children: [
              content(widget.payload?.template),
              SizedBox(height: controller!.mainPadding),
              Container(
                  height: screen.height,
                  child: CustomImageView(
                      widget.payload?.template?.originalImage ?? "",
                      height: screen.height))
            ])));
  }

  Widget content(Template? template) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 1),
              )
            ],
            color: ResourceManager().color!.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _itemContent(title: "Tên mẫu:", desc: template?.desc),
              SizedBox(height: 10),
              _itemContent(title: "Loại:", desc: template?.typeDecs),
              SizedBox(height: 10),
              _itemContent(
                  title: "Số câu:", desc: template?.question.toString()),
            ]));
  }

  Widget _itemContent({String? title, String? desc}) {
    double widthTitle = 100;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          width: widthTitle,
          child: Text(title ?? "",
              style: ResourceManager().text!.boldStyle.copyWith(fontSize: 17))),
      Expanded(
          child: Text(
        desc ?? "",
        style: ResourceManager().text!.normalStyle,
      ))
    ]);
  }

  Widget _share() {
    return InkWell(
        onTap: controller!.onSharePressed,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.share)));
  }
}

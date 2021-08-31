import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/view/child/rect_button.dart';
import 'package:camera_marker/view/child/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DialogClassType { New, Update }

class DialogClass extends StatelessWidget {
  final Function(MyClass temp)? onDone;
  final MyClass? temp;
  final DialogClassType? type;

  final TextEditingController _codeCtr = TextEditingController();
  final TextEditingController _nameCtr = TextEditingController();
  final TextEditingController _descCtr = TextEditingController();

  final FocusNode _codeFcn = FocusNode();
  final FocusNode _nameFcn = FocusNode();
  final FocusNode _descFcn = FocusNode();

  final confirmError = false.obs;
  final messageError = "".obs;

  DialogClass({Key? key, this.onDone, this.temp, this.type}) : super(key: key) {
    if (temp != null) {
      _codeCtr.text = temp?.code ?? "";
      _nameCtr.text = temp?.name ?? "";
      _descCtr.text = temp?.desc ?? "";
    }
  }

  static showNew({Function(MyClass temp)? onDone}) async {
    return Get.dialog(
        DialogClass(
          onDone: onDone,
          type: DialogClassType.New,
        ),
        barrierDismissible: false);
  }

  static showUpdate({Function(MyClass temp)? onDone, MyClass? temp}) async {
    return Get.dialog(
        DialogClass(
          onDone: onDone,
          temp: temp,
          type: DialogClassType.Update,
        ),
        barrierDismissible: false);
  }

  bool get isUpdate => type == DialogClassType.Update;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              child: _content(),
            ),
            SizedBox(height: 100),
            _button()
          ],
        ),
      ),
    );
  }

  Widget _button() {
    return Column(children: [
      Container(
        width: 200,
        child: RectButton(
          onTap: onCofirm,
          title: isUpdate ? "Cập nhật" : "Thêm mới",
          shadow: true,
          color: ResourceManager().color.lightBlue,
        ),
      ),
      SizedBox(height: 15),
      Container(
        width: 200,
        child: RectButton(
          title: "Hủy",
          shadow: true,
          color: ResourceManager().color.lightBlue,
          onTap: Get.back,
        ),
      )
    ]);
  }

  Widget _content() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Column(
        children: [
          _item("Mã lớp*", _codeFcn, _codeCtr),
          SizedBox(height: 7),
          _item("Tên lớp*", _nameFcn, _nameCtr),
          SizedBox(height: 7),
          _item("Mô tả", _descFcn, _descCtr),
          Obx(() => Visibility(
              visible: confirmError.value,
              child: Column(
                children: [SizedBox(height: 15), error()],
              )))
        ],
      ),
    );
  }

  Widget _item(String title, FocusNode fcn, TextEditingController ctr) {
    return Row(
      children: [
        Container(
          width: 70,
          child: Text(
            title,
            style: ResourceManager().text.boldStyle.copyWith(fontSize: 15),
          ),
        ),
        Expanded(
          child: TextFieldView(
            controller: ctr,
            focusNode: fcn,
            style: ResourceManager().text.normalStyle.copyWith(fontSize: 15),
          ),
        )
      ],
    );
  }

  Widget error() {
    return Text(
      messageError.value,
      style: ResourceManager()
          .text
          .normalStyle
          .copyWith(color: ResourceManager().color.error),
    );
  }

  bool validate() {
    if (_codeCtr.text.isEmpty || _nameCtr.text.isEmpty) {
      confirmError.value = true;
      if (_codeCtr.text.isEmpty) {
        _codeFcn.requestFocus();
        messageError.value = "Mã lớp không được bỏ trống";
      } else {
        _nameFcn.requestFocus();
        messageError.value = "Tên lớp không được bỏ trống";
      }
      return false;
    }
    confirmError.value = false;
    return true;
  }

  void onCofirm() {
    if (validate()) {
      if (onDone != null) {
        MyClass _class = temp ?? MyClass();
        _class.code = _codeCtr.text;
        _class.name = _nameCtr.text;
        _class.desc = _descCtr.text;
        onDone!(_class);
        Get.back();
      }
    }
  }
}

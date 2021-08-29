import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/model/config.dart';
import 'package:camera_marker/model/dropdown_gen.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/child/dropdown.dart';
import 'package:camera_marker/view/child/rect_button.dart';
import 'package:camera_marker/view/child/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

enum DialogExamType { New, Update }

// ignore: must_be_immutable
class DialogExam extends StatelessWidget {
  DialogExam({Key? key, this.exam, required this.type, required this.onConfirm})
      : super(key: key);

  final Exam? exam;
  final DialogExamType type;
  final Function(Exam exam) onConfirm;

  final TextEditingController titleCtr = TextEditingController();
  final TextEditingController pointCtr = TextEditingController();
  final TextEditingController timeCtr = TextEditingController();
  final TextEditingController dateStartCtr = TextEditingController();
  final TextEditingController timeStartCtr = TextEditingController();

  final FocusNode titleFcn = FocusNode();
  final FocusNode pointFcn = FocusNode();
  final FocusNode timeFcn = FocusNode();

  int? questionValue = Exam.questionsSelect[19];
  List<DropdownGen<int>> get myQuestions =>
      List<DropdownGen<int>>.from(Exam.questionsSelect
          .map((e) => DropdownGen<int>(title: e.toString(), value: e)));

  MyClass? myClassSeletected;
  List<DropdownGen<MyClass>> get myClass =>
      List<DropdownGen<MyClass>>.from(DataBaseCtr()
          .tbClass
          .entities
          .map((e) => DropdownGen<MyClass>(title: e.name, value: e)));

  Template? templateSelected;
  List<DropdownGen<Template>> get myTemplate =>
      List<DropdownGen<Template>>.from(DataBaseCtr()
          .tbTemplate
          .entities
          .map((e) => DropdownGen<Template>(title: e.title, value: e)));

  DateTime? dtStart;

  double get inputHeight => 35;
  double get inputSize => 13;

  static showNew({required Function(Exam exam) onConfirm}) {
    return Get.dialog(
        DialogExam(
          onConfirm: onConfirm,
          type: DialogExamType.New,
        ),
        barrierDismissible: false);
  }

  static showUpdate({Exam? exam, required Function(Exam exam) onConfirm}) {
    return Get.dialog(
        DialogExam(
          exam: exam,
          onConfirm: onConfirm,
          type: DialogExamType.Update,
        ),
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_content(context), _button()],
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item("Kì thi", titleFcn, titleCtr),
          SizedBox(height: 7),
          _itemDropdown<int>(
              title: "Câu trả lời",
              defaultValue: questionValue,
              items: myQuestions,
              onChanged: (int? value) {
                questionValue = value;
                print("CHỌN CÂU TRẢ LỜI ====================>$questionValue");
              }),
          _itemDropdown<MyClass>(
              title: "Lớp",
              defaultValue: myClassSeletected,
              items: myClass,
              onChanged: (MyClass? value) {
                myClassSeletected = value;
                print("CHỌN CÂU TRẢ LỜI ====================>$questionValue");
              }),
          SizedBox(height: 7),
          _item("Điểm", pointFcn, pointCtr,
              textInputType: TextInputType.number),
          SizedBox(height: 7),
          _itemDropdown<Template>(
              title: "Mẫu đề thi",
              defaultValue: templateSelected,
              items: myTemplate,
              onChanged: (Template? value) {
                templateSelected = value;
                print("CHỌN CÂU TRẢ LỜI ====================>$questionValue");
              }),
          SizedBox(height: 7),
          _item("Ngày bắt đầu", null, dateStartCtr,
              readonly: true, textInputType: TextInputType.number, onTap: () {
            showDate(context);
          }),
          SizedBox(height: 7),
          _item("Giờ bắt đầu", null, timeStartCtr,
              readonly: true, textInputType: TextInputType.number, onTap: () {
            showTime(context);
          }),
          SizedBox(height: 7),
          _item("Thời gian thi", timeFcn, timeCtr,
              textInputType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _item(String title, FocusNode? fcn, TextEditingController ctr,
      {TextInputType? textInputType,
      bool readonly = false,
      Function()? onTap}) {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            title,
            style:
                ResourceManager().text!.boldStyle.copyWith(fontSize: inputSize),
          ),
        ),
        Expanded(
          child: Container(
            height: inputHeight,
            child: TextFieldView(
              keyboardType: textInputType,
              controller: ctr,
              focusNode: fcn,
              readOnly: readonly,
              onTap: onTap,
              style: ResourceManager()
                  .text!
                  .normalStyle
                  .copyWith(fontSize: inputSize),
            ),
          ),
        )
      ],
    );
  }

  Widget _itemDropdown<T>(
      {required String title,
      required List<DropdownGen<T>> items,
      required void Function(T? dropdownGen)? onChanged,
      required T? defaultValue}) {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            title,
            style: ResourceManager().text!.boldStyle.copyWith(
                fontSize: inputSize, color: ResourceManager().color!.black),
          ),
        ),
        Expanded(child: _dropdown<T>(items, onChanged))
      ],
    );
  }

  Widget _dropdown<T>(
      List<DropdownGen<T>> items, void Function(T? dropdownGen)? onChanged) {
    return CustomDropdown<T>(
        onChange: onChanged, items: items, selectedType: items[0]);
  }

  Widget _button() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 14).copyWith(bottom: 15),
        child: Row(children: [
          Expanded(
            child: RectButton(
              textSize: 15,
              borderColor: ResourceManager().color!.des,
              textColor: ResourceManager().color!.des,
              color: ResourceManager().color!.white,
              title: "Hủy",
              onTap: () {
                Get.back();
              },
            ),
          ),
          SizedBox(width: 14),
          Expanded(
              child: RectButton(
                  textSize: 15,
                  title: "Tạo kì thi",
                  onTap: () {
                    Get.back();
                    onConfirm(Exam());
                  }))
        ]));
  }

  void showDate(BuildContext context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1997, 14, 03), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      if (dtStart != null) {
        dtStart = DateTime(date.year, date.month, date.day, dtStart?.hour ?? 0,
            dtStart?.minute ?? 0);
      } else {
        dtStart = DateTime(date.year, date.month, date.day);
      }
      Utils.statusPrint(
          "DATE PICK", Utils.dateToStr(dtStart, pattern: Utils.DMYHM));
      dateStartCtr.text = Utils.dateToStr(date);
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }

  void showTime(BuildContext context) {
    DatePicker.showTimePicker(context,
        showTitleActions: true, showSecondsColumn: false, onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
      if (dtStart != null) {
        dtStart = DateTime(dtStart?.year ?? 0, dtStart?.month ?? 0,
            dtStart?.day ?? 0, date.hour, date.minute);
      } else {
        dtStart = DateTime(0, 0, 0, date.hour, date.minute);
      }
      Utils.statusPrint(
          "DATE PICK", Utils.dateToStr(dtStart, pattern: Utils.DMYHM));
      timeStartCtr.text = Utils.dateToStr(date, pattern: Utils.HM);
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }
}

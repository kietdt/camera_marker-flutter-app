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
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com

enum DialogExamType { New, Update }

// ignore: must_be_immutable
class DialogExam extends StatelessWidget {
  DialogExam({Key? key, this.exam, required this.type, required this.onConfirm})
      : super(key: key) {
    titleCtr.text = this.exam?.title ?? "";
    questionValue = this.exam?.question;
    myClassSeletected = this.exam?.myClass;
    pointSelected = this.exam?.maxPoint;
    templateSelected = this.exam?.template;
    dateStartCtr.text = Utils.dateToStr(this.exam?.startAt);
    timeStartCtr.text = Utils.dateToStr(this.exam?.startAt, pattern: Utils.HM);
    // timeCtr.text = this.exam?.minutes?.toString() ?? "";
    dtStart = this.exam?.startAt;
    durationSelected = this.exam?.minutes;
    // validate();
  }

  final Exam? exam;
  final DialogExamType type;
  final Function(Exam exam) onConfirm;

  final TextEditingController titleCtr = TextEditingController();
  // final TextEditingController pointCtr = TextEditingController();
  // final TextEditingController timeCtr = TextEditingController();
  final TextEditingController dateStartCtr = TextEditingController();
  final TextEditingController timeStartCtr = TextEditingController();

  final FocusNode titleFcn = FocusNode();
  // final FocusNode pointFcn = FocusNode();
  // final FocusNode timeFcn = FocusNode();

  late int? questionValue;
  late Rx<DropdownGenList<int>> myQuestions = DropdownGenList(
          List<DropdownGen<int>>.from(templateSelected?.questionsSelect.map(
                  (e) =>
                      DropdownGen<int>(title: e.toString(), value: e, id: e)) ??
              [DropdownGen<int>(title: 0.toString(), value: 0, id: 0)]))
      .obs;

  late MyClass? myClassSeletected;
  DropdownGenList<MyClass> get myClass => DropdownGenList(
      List<DropdownGen<MyClass>>.from(DataBaseCtr().tbClass.entities.map((e) =>
          DropdownGen<MyClass>(title: e.titleDisplay, value: e, id: e.id))));

  late Template? templateSelected;
  DropdownGenList<Template> get myTemplate => DropdownGenList(
      List<DropdownGen<Template>>.from(DataBaseCtr().tbTemplate.entities.map(
          (e) => DropdownGen<Template>(title: e.title, value: e, id: e.id))));

  late int? durationSelected;
  DropdownGenList<int> duration = DropdownGenList(List<DropdownGen<int>>.from(
      List.generate(171, (index) => index + 10)
          .map((e) => DropdownGen<int>(title: e.toString(), value: e, id: e))));

  late double? pointSelected;
  DropdownGenList<int> points = DropdownGenList(List<DropdownGen<int>>.from(
      List.generate(100, (index) => index + 1)
          .map((e) => DropdownGen<int>(title: e.toString(), value: e, id: e))));

  DateTime? dtStart;

  double get inputHeight => 35;
  double get inputSize => 13;
  bool get isNew => type == DialogExamType.New;

  late var canSubmit = isNew ? false.obs : true.obs;

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
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25)
          .copyWith(bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item("Kì thi*", titleFcn, titleCtr, context, unFocus: false),
          SizedBox(height: 7),
          _itemDropdown<Template>(
              title: "Mẫu đề thi*",
              defaultValue: DropdownGen<Template>(id: templateSelected?.id),
              items: myTemplate,
              onChanged: (Template? value) {
                if ((questionValue ?? 0) > (value?.question ?? 0)) {
                  questionValue = null;
                }
                templateSelected = value;
                myQuestions.value = DropdownGenList(List<DropdownGen<int>>.from(
                    templateSelected?.questionsSelect.map((e) =>
                            DropdownGen<int>(
                                title: e.toString(), value: e, id: e)) ??
                        []));
                print("CHỌN CÂU TRẢ LỜI ====================>$questionValue");
                validate(context);
              }),
          SizedBox(height: 7),
          Obx(() => _itemDropdown<int>(
              title: "Số câu hỏi*",
              defaultValue: DropdownGen<int>(id: questionValue),
              items: myQuestions.value,
              onChanged: (int? value) {
                questionValue = value;
                print("CHỌN CÂU TRẢ LỜI ====================>$questionValue");
                validate(context);
              })),
          _itemDropdown<MyClass>(
              title: "Lớp*",
              defaultValue: DropdownGen<MyClass>(id: myClassSeletected?.id),
              items: myClass,
              onChanged: (MyClass? value) {
                myClassSeletected = value;
                print("CHỌN CÂU TRẢ LỜI ====================>$questionValue");
                validate(context);
              }),
          SizedBox(height: 7),
          _itemDropdown<int>(
              title: "Thang điểm*",
              defaultValue: DropdownGen<int>(id: pointSelected?.toInt()),
              items: points,
              onChanged: (int? value) {
                pointSelected = (value ?? 0) + 0.0;
                print(
                    "CHỌN THỜI GIAN THI ====================>$durationSelected");
                validate(context);
              },
              suffixText: ""),
          SizedBox(height: 7),
          _item("Ngày bắt đầu*", null, dateStartCtr, context,
              readonly: true, textInputType: TextInputType.number, onTap: () {
            showDate(context);
          }),
          SizedBox(height: 7),
          _item("Giờ bắt đầu*", null, timeStartCtr, context,
              readonly: true, textInputType: TextInputType.number, onTap: () {
            showTime(context);
          }),
          SizedBox(height: 7),
          // _itemTime("Thời gian thi*", timeFcn, timeCtr,
          //     textInputType: TextInputType.number, suffixText: "Phút"),
          _itemDropdown<int>(
              title: "Thời gian thi*",
              defaultValue: DropdownGen<int>(id: durationSelected),
              items: duration,
              onChanged: (int? value) {
                durationSelected = value;
                print(
                    "CHỌN THỜI GIAN THI ====================>$durationSelected");
                validate(context);
              },
              suffixText: "Phút"),
          SizedBox(height: 15),
          Text(
            "Điền những phần có dấu * để tạo kì thi",
            textAlign: TextAlign.center,
            style: ResourceManager().text.normalStyle.copyWith(
                fontSize: inputSize, color: ResourceManager().color.error),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, FocusNode? fcn, TextEditingController ctr,
      BuildContext context,
      {TextInputType? textInputType,
      bool readonly = false,
      Function(String)? onChanged,
      String? suffixText,
      Function()? onTap,
      bool unFocus = true}) {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            title,
            style:
                ResourceManager().text.boldStyle.copyWith(fontSize: inputSize),
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
              suffixText: suffixText,
              onChanged: (String text) {
                if (onChanged != null) {
                  onChanged(text);
                }
                validate(context, unFocus: unFocus);
              },
              style: ResourceManager()
                  .text
                  .normalStyle
                  .copyWith(fontSize: inputSize),
            ),
          ),
        )
      ],
    );
  }

  // Widget _itemTime(String title, FocusNode? fcn, TextEditingController ctr,
  //     {TextInputType? textInputType,
  //     bool readonly = false,
  //     String? suffixText,
  //     Function()? onTap}) {
  //   return Row(children: [
  //     Container(
  //       width: 100,
  //       child: Text(
  //         title,
  //         style: ResourceManager().text.boldStyle.copyWith(fontSize: inputSize),
  //       ),
  //     ),
  //     Container(
  //       width: 50,
  //       height: inputHeight,
  //       child: TextFieldView(
  //         keyboardType: textInputType,
  //         controller: ctr,
  //         focusNode: fcn,
  //         readOnly: readonly,
  //         maxLength: 4,
  //         onTap: onTap,
  //         onChanged: (text) {
  //           validate();
  //         },
  //         style:
  //             ResourceManager().text.normalStyle.copyWith(fontSize: inputSize),
  //       ),
  //     ),
  //     SizedBox(width: 7),
  //     Text(suffixText ?? "",
  //         style: ResourceManager().text.normalStyle.copyWith(
  //             fontSize: inputSize, color: ResourceManager().color.des))
  //   ]);
  // }

  Widget _itemDropdown<T>(
      {required String title,
      required DropdownGenList<T> items,
      required void Function(T? dropdownGen)? onChanged,
      required DropdownGen<T>? defaultValue,
      String? suffixText}) {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            title,
            style: ResourceManager().text.boldStyle.copyWith(
                fontSize: inputSize, color: ResourceManager().color.black),
          ),
        ),
        Expanded(child: _dropdown<T>(items, onChanged, defaultValue)),
        if (suffixText != null) ...[
          SizedBox(width: 7),
          Expanded(flex: 1, child: Text(suffixText))
        ]
      ],
    );
  }

  Widget _dropdown<T>(DropdownGenList<T> items,
      void Function(T? dropdownGen)? onChanged, DropdownGen<T>? defaultValue) {
    return CustomDropdown<T>(
        onChange: onChanged, items: items, selectedType: defaultValue);
  }

  Widget _button() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 14).copyWith(bottom: 15),
        child: IntrinsicHeight(
          child: Row(children: [
            Expanded(
              child: RectButton(
                textSize: 15,
                borderColor: ResourceManager().color.des,
                textColor: ResourceManager().color.des,
                color: ResourceManager().color.white,
                title: "Hủy",
                onTap: () {
                  Get.back();
                },
              ),
            ),
            SizedBox(width: 14),
            Expanded(
                child: Obx(() => RectButton(
                    disable: !canSubmit.value,
                    textSize: 15,
                    title: isNew ? "Tạo kì thi" : "Cập nhật",
                    onTap: onSubmit)))
          ]),
        ));
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

  void onSubmit() {
    Get.back();
    Exam exam = Exam(
        id: this.exam?.id,
        title: titleCtr.text.trim(),
        question: questionValue,
        myClassId: myClassSeletected?.id,
        maxPoint: pointSelected,
        templateId: templateSelected?.id,
        startAt: dtStart,
        resultIds: this.exam?.resultIds,
        answerIds: this.exam?.answerIds,
        minutes: durationSelected);
    if (this.exam?.templateId != null &&
        this.exam?.templateId != templateSelected?.id &&
        (exam.answer.length > 0 || exam.result.length > 0)) {
      //TODO: vì đổi mẫu đề thi có thể đổi từ mẫu chọn 1 => chọn nhiều
      //TODO: ràng buộc chỗ này để khỏi xử lý nhiều
      //TODO: vì đổi mẫu mã đề có thể sẽ đổi cách chấm
      DialogConfirm.show(
          message:
              "Bạn đã thay đổi mẫu bảng trả lời, các đáp án và bài chấm đã tạo sẽ bị xóa. Tiếp tục?",
          onRight: () async {
            await DataBaseCtr().tbAnswer.deleteAnswerList(exam.answer, null);
            await DataBaseCtr().tbResult.deleteResultList(exam.result, null);
            exam.answerIds = null;
            exam.resultIds = null;
            submit(exam);
          },
          rightTitle: "Tiếp tục");
    } else {
      submit(exam);
    }
  }

  void submit(Exam exam) {
    onConfirm(exam);
  }

  void validate(BuildContext context, {bool unFocus = true}) {
    bool valid = true;
    if (unFocus) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
    if (titleCtr.text.isEmpty) {
      valid = false;
    } else if (pointSelected == null) {
      valid = false;
    } else if (timeStartCtr.text.isEmpty) {
      valid = false;
    } else if (dateStartCtr.text.isEmpty) {
      valid = false;
    } else if (durationSelected == null) {
      valid = false;
    } else if (questionValue == null) {
      valid = false;
    } else if (myClassSeletected == null) {
      valid = false;
    } else if (templateSelected == null) {
      valid = false;
    }
    canSubmit.value = valid;
  }
}

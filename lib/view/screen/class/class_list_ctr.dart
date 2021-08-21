import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/view/dialog/dialog_class.dart';
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'class_list_page.dart';

class ClassListCtr extends BaseController<ClassListState> {
  ClassListCtr(ClassListState state) : super(state) {
    getClass();
    deleteCtr = AnimationController(
        value: 0, vsync: state, duration: Duration(milliseconds: 300));
  }

  late AnimationController deleteCtr;

  var classList = List<Class>.empty().obs;
  var showSelect = false.obs;
  var selecteList = [].obs;

  double get mainPadding => 15;

  void initSelectedList() {
    List<bool> temp = [];
    List.generate(classList.length, (index) {
      temp.add(false);
    });
    selecteList.value = temp;
  }

  void getClass() {
    classList.value = List<Class>.from(DataBaseCtr().tbClass.entities);
    initSelectedList();
  }

  void resetSelectList() {
    selecteList.forEach((element) {
      element.value = false;
    });
  }

  void showNew({Class? item}) {
    DialogClass.showNew(onDone: addClass);
  }

  void showUpdate(Class? item, int index) {
    if (showSelect.value) {
      oncheckBox(index);
    } else {
      if (item != null) {
        DialogClass.showUpdate(onDone: updateClass, temp: item);
      }
    }
  }

  void addClass(Class temp) async {
    await DataBaseCtr().tbClass.addClass(temp);
    topSnackBar("Thông báo", "Thêm mới thành công");
    getClass();
  }

  void updateClass(Class temp) async {
    await DataBaseCtr().tbClass.updateClass(temp);
    topSnackBar("Thông báo", "Cập nhật thành công");
    getClass();
  }

  void onSelect() {
    if (!deleteCtr.isAnimating) {
      if (!showSelect.value) {
        showSelect.value = !showSelect.value;
        deleteCtr.forward();
      } else {
        deleteCtr
            .reverse()
            .then((value) => showSelect.value = !showSelect.value);
      }
    }
  }

  void oncheckBox(int index) {
    selecteList[index] = !selecteList[index];
  }

  void onDelete() {
    List<Class> temp = [];
    List.generate(selecteList.length, (index) {
      if (selecteList[index]) {
        temp.add(classList[index]);
      }
    });
    if (temp.length > 0) {
      DialogConfirm.show(
          message: "Bạn có chắc muốn xóa ${temp.length} lớp đang chọn?",
          onRight: () {
            temp.forEach((element) {
              DataBaseCtr().tbClass.deleteClass(element);
            });
            onSelect();
            getClass();
            topSnackBar("Thông báo", "Đã xóa ${temp.length} lớp");
          });
    } else {
      if (!(Get.isSnackbarOpen ?? false)) {
        topSnackBar("Thông báo", "Bạn hãy chọn một lớp để xóa");
      }
    }
  }
}

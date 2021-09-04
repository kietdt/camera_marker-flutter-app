import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/view/extend/list_select/list_select.dart';
import 'package:flutter/animation.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

abstract class ListSelectCtr<S extends State, D> extends BaseController<S> {
  ListSelectCtr(S state) : super(state) {
    deleteCtr = AnimationController(
        value: 0,
        vsync: state as ListSelect,
        duration: Duration(milliseconds: 300));
  }

  var items = List<D>.empty().obs;
  var showSelect = false.obs;
  var selecteList = [].obs;

  bool showAdd = true;

  String get emptyMessage => "Không có nội dung nào";
  String get title => "";
  double get mainPadding => 15;

  late AnimationController deleteCtr;

  void oncheckBox(int index) {
    selecteList[index] = !selecteList[index];
  }

  void initSelectedList() {
    List<bool> temp = [];
    List.generate(items.length, (index) {
      temp.add(false);
    });
    selecteList.value = temp;
  }

  void resetSelectList() {
    selecteList.forEach((element) {
      element.value = false;
    });
  }

  void onTap(D? item, int index) {
    if (showSelect.value) {
      oncheckBox(index);
    } else {
      if (item != null) {
        showUpdate(item, index);
      }
    }
  }

  //không override lại hàm này
  void onDoubleTap(D? item, int index) {
    if (showSelect.value) {
      oncheckBox(index);
    } else {
      if (item != null) {
        onChildDoubleTap(item, index);
      }
    }
  }

  //override lại hàm này
  void onChildDoubleTap(D? item, int index) {}

  void onSelect() {
    if (!deleteCtr.isAnimating) {
      if (!showSelect.value) {
        showSelect.value = !showSelect.value;
        deleteCtr.forward();
      } else {
        deleteCtr.reverse().then((value) {
          showSelect.value = !showSelect.value;
          initSelectedList();
        });
      }
    }
  }

  void showUpdate(D? item, int index);

  void onDelete();

  void showNew();
}

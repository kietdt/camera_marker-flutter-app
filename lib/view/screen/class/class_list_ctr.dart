import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/view/dialog/dialog_class.dart';
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:camera_marker/view/extend/list_select/list_select_ctr.dart';

import 'package:get/get.dart';
import 'class_list_page.dart';

class ClassListCtr extends ListSelectCtr<ClassListState, MyClass> {
  ClassListCtr(ClassListState state) : super(state) {
    getClass();
  }

  @override
  String get title => "Lớp";

  @override
  void showNew({MyClass? item}) {
    DialogClass.showNew(onDone: addClass);
  }

  @override
  void showUpdate(MyClass? item, int index) {
    DialogClass.showUpdate(onDone: updateClass, temp: item);
  }

  @override
  void onDelete() {
    List<MyClass> temp = [];
    List.generate(selecteList.length, (index) {
      if (selecteList[index]) {
        temp.add(items[index]);
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

  void getClass() {
    items.value = List<MyClass>.from(DataBaseCtr().tbClass.entities);
    initSelectedList();
  }

  void addClass(MyClass temp) async {
    await DataBaseCtr().tbClass.addClass(temp);
    topSnackBar("Thông báo", "Thêm mới thành công");
    getClass();
  }

  void updateClass(MyClass temp) async {
    await DataBaseCtr().tbClass.updateClass(temp);
    topSnackBar("Thông báo", "Cập nhật thành công");
    getClass();
  }
}

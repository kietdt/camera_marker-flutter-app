//created by Kietdt 01/09/2021
//contact email: dotuankiet1403@gmail.com

class DropdownGenList<T> {
  DropdownGenList(this.value);
  final List<DropdownGen<T>> value;

  //Drop down DropdownButton băt buộc truyền vào default value phải có trong list
  //Dùng hàm này để get giá trị trong list
  DropdownGen<T>? getItem(DropdownGen<T>? item) {
    int index = value.indexWhere((element) => element.id == item?.id);
    if (index >= 0) {
      return value[index];
    }
    return null;
  }
}

class DropdownGen<T> {
  T? value;
  String? title;

  // nếu T là một type int, string, ... => truyền vào chính giá trị của T
  // nếu T là một class thì truyền vào id của class
  dynamic id;

  DropdownGen({this.value, this.title, required this.id});
}

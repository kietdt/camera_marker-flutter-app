import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/dropdown_gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomDropdown<T> extends StatelessWidget {
  final Function(T? value)? onChange;
  final TextStyle? style;

  late var selectedValue;
  List<DropdownGen<T>>? items = [];

  CustomDropdown(
      {Key? key,
      this.onChange,
      this.items,
      DropdownGen<T>? selectedType,
      this.style})
      : super(key: key) {
    selectedValue = selectedType.obs;
    if (items != null) {
      items = items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButton<DropdownGen<T>>(
          value: selectedValue?.value,
          elevation: 0,
          isExpanded: true,
          style: style ??
              ResourceManager().text!.normalStyle.copyWith(fontSize: 13),
          onChanged: (value) {
            selectedValue?.value = value!;
            if (onChange != null) {
              onChange!(value?.value);
            }
          },
          items: items!
              .map<DropdownMenuItem<DropdownGen<T>>>((DropdownGen<T> value) {
            return DropdownMenuItem<DropdownGen<T>>(
              value: value,
              child: Text(value.title ?? "",
                  style: style ??
                      ResourceManager().text!.normalStyle.copyWith(
                          fontSize: 13, color: ResourceManager().color!.black)),
            );
          }).toList(),
        ));
  }
}

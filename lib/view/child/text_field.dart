import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

class TextFieldView extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final EdgeInsets? contentPadding;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  const TextFieldView(
      {Key? key,
      this.controller,
      this.hint,
      this.style,
      this.hintStyle,
      this.contentPadding,
      this.keyboardType,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(color: ResourceManager().color!.des)),
      child: TextFormField(
        controller: controller,
        style: style,
        keyboardType: keyboardType,
        cursorColor: ResourceManager().color!.primary,
        focusNode: focusNode,
        decoration: InputDecoration(
            hintStyle: hintStyle,
            hintText: hint,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero),
      ),
    );
  }
}

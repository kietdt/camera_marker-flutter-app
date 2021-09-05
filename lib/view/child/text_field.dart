import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class TextFieldView extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final EdgeInsets? contentPadding;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool? enable;
  final bool? readOnly;
  final Function()? onTap;
  final String? suffixText;
  final int? maxLength;
  final String? counterText;
  final Function(String)? onChanged;

  const TextFieldView(
      {Key? key,
      this.controller,
      this.hint,
      this.style,
      this.hintStyle,
      this.contentPadding,
      this.keyboardType,
      this.focusNode,
      this.onTap,
      this.readOnly,
      this.suffixText,
      this.maxLength,
      this.counterText,
      this.onChanged,
      this.enable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: style,
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: ResourceManager().color.primary,
      focusNode: focusNode,
      onTap: onTap,
      readOnly: readOnly ?? false,
      enabled: enable,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
          hintStyle: hintStyle,
          hintText: hint,
          suffixText: suffixText,
          counterText: counterText ?? "",
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(horizontal: 7, vertical: 5)),
    );
  }
}

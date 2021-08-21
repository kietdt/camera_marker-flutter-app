import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

class RectButton extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final bool shadow;
  final Color? borderColor;
  final Color? color;
  final Color? textColor;

  const RectButton(
      {Key? key,
      this.onTap,
      this.title,
      this.shadow = false,
      this.borderColor,
      this.textColor,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: color ?? ResourceManager().color!.primary,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
            ),
            boxShadow: shadow
                ? [
                    BoxShadow(
                      color: ResourceManager().color!.primary.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    )
                  ]
                : []),
        child: Text(this.title ?? "Xác nhận",
            style: ResourceManager().text!.boldStyle.copyWith(
                color: textColor ?? ResourceManager().color!.white,
                fontSize: 20)),
      ),
    );
  }
}

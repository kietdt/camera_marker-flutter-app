import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

class FloatingActionAdd extends StatelessWidget {
  final Function()? onTap;
  final Color? color;

  const FloatingActionAdd({Key? key, this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(right: 30, bottom: 30),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ResourceManager().color.primary.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              )
            ],
            color: ResourceManager().color.white,
            border: Border.all(
                color: color ?? ResourceManager().color.primary, width: 2)),
        child: InkWell(
            onTap: onTap,
            child: Icon(Icons.add,
                color: color ?? ResourceManager().color.primary)));
  }
}

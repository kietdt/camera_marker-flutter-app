import 'package:flutter/material.dart';
import 'dart:math' as math;

class BoundingBox extends StatelessWidget {
  final List<dynamic> results;
  final double? previewH;
  final double? previewW;
  final double? screenH;
  final double? screenW;

  double get scaleW => (previewW ?? 1) / (screenW ?? 1);
  double get scaleH => (previewH ?? 1) / (screenH ?? 1);

  BoundingBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBox() {
      return results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var _scaleW, _scaleH, x, y, w, h;

        x = _x.toDouble() / scaleW;
        y = _y.toDouble() / scaleH;
        w = _w.toDouble() / scaleW;
        h = _h.toDouble() / scaleH;
        print(
            "$x $y $w $h - ${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%");
        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                width: 3.0,
              ),
            ),
            child: Text(
              "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: _renderBox(),
    );
  }
}

import 'package:camera_marker/model/recognition.dart';
import 'package:flutter/material.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class BoundingBox extends StatelessWidget {
  final List<Recognition> results;
  final double? previewH;
  final double? previewW;
  final double? screenH;
  final double? screenW;
  final bool isDetected;

  double get scaleW => (previewW ?? 1) / (screenW ?? 1);
  double get scaleH => (previewH ?? 1) / (screenH ?? 1);

  static double lineWidth = 3;

  BoundingBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
    this.isDetected,
  );

  @override
  Widget build(BuildContext context) {
    // List<Widget> _renderBox() {
    //   return results.map((re) {
    //     var _x = re.offset?.dx ?? 0.0;
    //     var _w = re.size?.width ?? 0.0;
    //     var _y = re.offset?.dy ?? 0.0;
    //     var _h = re.size?.height ?? 0.0;

    //     var _scaleW, _scaleH, x, y, w, h;

    //     x = _x.toDouble() / scaleW;
    //     y = _y.toDouble() / scaleH;
    //     w = _w.toDouble() / scaleW;
    //     h = _h.toDouble() / scaleH;
    //     print(
    //         "$x $y $w $h - ${re.detectedClass} ${((re.confidenceInClass ?? 0.0) * 100).toStringAsFixed(0)}%");
    //     return Positioned(
    //       left: x,
    //       top: y,
    //       width: w,
    //       height: h,
    //       child: _buildSquare(),
    //     );
    //   }).toList();
    // }

    // return Stack(
    //   clipBehavior: Clip.none,
    //   children: _renderBox(),
    // );
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            2,
            (index) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildSquare(), _buildSquare()],
                )));
  }

  Widget _buildSquare() {
    return Container(
      width: 100,
      height: 150,
      padding: EdgeInsets.only(top: 5.0, left: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDetected ? Colors.red : Color.fromRGBO(37, 213, 253, 1.0),
          width: lineWidth,
        ),
      ),
      // child: Text(
      //   "${re.detectedClass} ${((re.confidenceInClass ?? 0.0) * 100).toStringAsFixed(0)}%",
      //   style: TextStyle(
      //     color: Color.fromRGBO(37, 213, 253, 1.0),
      //     fontSize: 14.0,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
    );
  }
}

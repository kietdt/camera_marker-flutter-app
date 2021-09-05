import 'package:flutter/material.dart';


//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class Recognition {
  final Offset? offset;
  final Size? size;
  final String? detectedClass;
  final int? confidenceInClass;

  Recognition(
      {this.offset, this.size, this.detectedClass, this.confidenceInClass});
}

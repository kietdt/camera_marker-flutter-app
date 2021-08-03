import 'package:flutter/material.dart';

class Recognition {
  final Offset? offset;
  final Size? size;
  final String? detectedClass;
  final int? confidenceInClass;

  Recognition(
      {this.offset, this.size, this.detectedClass, this.confidenceInClass});
}

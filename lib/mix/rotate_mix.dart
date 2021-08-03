import 'dart:math';

import 'package:flutter/material.dart';

//created by Kietdt 28/07/2021
class RotateMix {
  List<List<double>>? matix;

  void initMatrix(num radians) {
    double _sin = sin(radians);
    double _cos = cos(radians);
    matix = [
      [_cos, -_sin, 0],
      [_sin, _cos, 0],
      [0, 0, 1]
    ];
  }

  // đổi gốc tạo độ sang gốc tọa độ mới, nếu không truyền vào gốc tọa độ gốc thì mặc định là (0,0)
  Offset shiftPoint(
    Offset point,
    Offset targetOrigin, {
    Offset origin = Offset.zero,
  }) {
    origin += targetOrigin;
    point -= origin;
    return point;
  }

  // kết quả list<double> = [dx,dy,w,h] => đã được rotate
  List<double> topLeftRotate(Offset topLeft, Size size) {
    // vì native chỉ gửi sang tọa độ góc trái trên và chiều dài + rộng nên phải tìm lại góc trái trên khi xoay hình

    List<Offset> points = [
      topLeft, // _topLeft
      Offset(topLeft.dx + size.width, topLeft.dy), // _topRight
      Offset(topLeft.dx, topLeft.dy - size.height), // _botLeft
      Offset(topLeft.dx + size.width, topLeft.dy - size.height), // _botRight
    ];

    // xoay bốn điểm của rectangle
    points[0] = rotatePoint(points[0]);
    points[1] = rotatePoint(points[1]);
    points[2] = rotatePoint(points[2]);
    points[3] = rotatePoint(points[3]);

    //tìm điểm nhỏ nhất và lớn nhất
    Offset topLeftPoint = points[0];
    Offset botRightPoint = points[0];

    // sort points theo điều kiện tăng dần => điểm nhỏ nhất là điểm top left,
    // điểm lớn nhất có chưa chiều dài cạnh của hình cần vẽ
    // vì point có thể không phải là số nguyên nên phải làm tròn
    for (int i = 1; i < points.length; i++) {
      if (points[i].dx.round() <= topLeftPoint.dx.round() &&
          points[i].dy.round() >= topLeftPoint.dy.round()) {
        topLeftPoint = points[i];
      }
      if (points[i].dx.round() >= botRightPoint.dx.round() &&
          points[i].dy.round() <= botRightPoint.dy.round()) {
        botRightPoint = points[i];
      }
    }

    return [
      topLeftPoint.dx, // dx top left
      topLeftPoint.dy, // dy top left
      (botRightPoint.dx - topLeftPoint.dx), // width
      (topLeftPoint.dy - botRightPoint.dy) // height
    ];
  }

  // xoay tọa độ
  Offset rotatePoint(Offset point) {
    // affine là thuật toán xoay 3d, trong trường hợp này xoay ảnh 2d => z = 0
    List<double> offsetZ = multiplyMatrix([point.dx, point.dy, 0]);
    return Offset(offsetZ[0], offsetZ[1]);
  }

  // nhân tọa độ với ma trận đã khởi tạo ở initMatrix()
  List<double> multiplyMatrix(List<double> offsetZ) {
    double dx = multiplyTemp(offsetZ, colMatrix(0));
    double dy = multiplyTemp(offsetZ, colMatrix(1));
    double dz = multiplyTemp(offsetZ, colMatrix(2));
    return [dx, dy, dz];
  }

  // nhân hàng và cột
  double multiplyTemp(List<double> row, List<double> col) {
    double value = row[0] * col[0] + row[1] * col[1] + row[2] * col[2];
    return value;
  }

  // lấy giá trị từng cột
  List<double> colMatrix(int index) {
    return [matix![0][index], matix![1][index], matix![2][index]];
  }
}

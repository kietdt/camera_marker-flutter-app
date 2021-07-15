class DrawInfo {
  double? width;
  double? height;
  List<List<double>>? points;

  DrawInfo.fromJson(Map<String, dynamic> json) {
    width = (json["width"] ?? 0) + 0.0;
    height = (json["height"] ?? 0) + 0.0;
    points = List.from(json["points"].map((points) =>
        List<double>.from(points.map((point) => (point ?? 0) + 0.0))));
  }
}

import 'package:flutter/material.dart';

class Draw extends CustomPainter {
  List<Offset> points;
  Draw({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.greenAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Draw oldDelegate) => oldDelegate.points != points;
}

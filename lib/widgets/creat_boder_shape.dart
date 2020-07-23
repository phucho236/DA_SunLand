import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/utils.dart';

class MyPainter extends CustomPainter {
  MyPainter({this.borderWidth, this.radius, this.colorBoder});
  final double radius;
  final double borderWidth;
  final Color colorBoder;
  @override
  void paint(Canvas canvas, Size size) {
    final rrectBorder =
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final rrectShadow = RRect.fromRectAndRadius(
        Offset(0.4, 0.4) & size, Radius.circular(radius));

    final shadowPaint = Paint()
      ..strokeWidth = borderWidth
      ..color = Colors.black.withOpacity(.6)
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    final borderPaint = Paint()
      ..strokeWidth = borderWidth
      ..color = colorBoder
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrectShadow, shadowPaint);
    canvas.drawRRect(rrectBorder, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

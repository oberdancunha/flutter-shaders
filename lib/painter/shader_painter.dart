import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

@immutable
final class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;

  const ShaderPainter({required this.shader, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time);
    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

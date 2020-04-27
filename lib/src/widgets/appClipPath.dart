import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AppClipDart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(-125, 0.0);
    path.quadraticBezierTo(size.width / 2, size.height, size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) {
    // TODO: implement shouldReclip
    return null;
  }
}

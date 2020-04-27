import "package:flutter/material.dart";
import 'dart:math';

class CurvedShape extends StatelessWidget {
  final bool transparent;
  CurvedShape({this.transparent})
  ;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: (MediaQuery.of(context).size.height / 2.25),
      child: CustomPaint(
        painter: _MyPainter(transparent, context),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  final bool transparent;
  BuildContext context;
   _MyPainter(this.transparent, this.context);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = transparent!=null?Colors.transparent:Theme.of(context).primaryColor;

    Offset topLeft = Offset(0, 0);
    Offset bottomLeft = Offset(0, (size.height / 2.00));
    Offset topRight = Offset(size.width, 0);

    Path path = Path()
      ..moveTo(topLeft.dx,
          topLeft.dy) // this move isn't required since the start point is (0,0)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, (size.height / 2))
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';

class MicroCircle extends StatefulWidget {
  int groupId;
  Color colorCricle;
  MicroCircle({this.groupId});

  @override
  _MicroCircleState createState() => _MicroCircleState();
}

class _MicroCircleState extends State<MicroCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getMicrocircle(),
    );
  }

  Widget getMicrocircle() {
    if (widget.groupId == 1) {
      widget.colorCricle = Colors.red;
    } else if (widget.groupId == 2) {
      widget.colorCricle = Colors.yellow;
    } else {
      widget.colorCricle = Colors.lightGreen;
    }

    return Container(
      child: Container(
        width: 10.0,
        height: 10.0,
        decoration: new BoxDecoration(
          color: widget.colorCricle,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

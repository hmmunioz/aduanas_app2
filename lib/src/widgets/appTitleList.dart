
  
import 'package:flutter/material.dart';

class TitleList extends StatefulWidget {
  final String _value;
  final String _listLength;
  TitleList(this._value, this._listLength);

  @override
  _TitleListState createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget._value,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).highlightColor),
      ),
      trailing: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border:
              Border.all(width: 3.0, color: Color.fromRGBO(142, 144, 146, 1)),
          borderRadius: BorderRadius.all(
              Radius.circular(8.0) //         <--- border radius here
              ),
        ),
        child: Text(
          widget._listLength,
          style: TextStyle( fontSize: 19, color: Theme.of(context).highlightColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
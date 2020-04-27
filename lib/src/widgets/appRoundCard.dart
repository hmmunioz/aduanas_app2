import 'package:flutter/material.dart';

import 'appTypewriterBox.dart';

class AppRoundCard extends StatefulWidget {
  final String inputText;
  final Function onClick;
  final IconData iconCard;

  final Color inputColor;
  const AppRoundCard(
      {this.inputText, this.iconCard, this.inputColor, this.onClick});
  @override
  _AppRoundCardState createState() => _AppRoundCardState();
}

class _AppRoundCardState extends State<AppRoundCard> {
  @override
  Widget build(BuildContext context) {
    return 
    Container(
       margin: EdgeInsets.only(left: 12.0, right: 12.0, top: 20.0, bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0) //         <--- border radius here
          ),
         border: Border.all(
        color:Theme.of(context).accentColor , //                   <--- border color
        width:2.0,
      ),
      ),
      child:    Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0.2,
      child: InkWell(
            onTap: () {
               widget.onClick();
            },
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  widget.iconCard,
                  size: 55.0,
                  color: widget.inputColor,
                ),
                AppTypeWriter(textWriter:widget.inputText ,textStyle: TextStyle(color: widget.inputColor))               
              ],
            )),
          )     
    ),
    );
  }
}

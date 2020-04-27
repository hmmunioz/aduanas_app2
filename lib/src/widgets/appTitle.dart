import 'package:flutter/material.dart';

import 'appTypewriterBox.dart';

class AppTitle extends StatelessWidget {
  final String inputText;
  final String secondText;
  final bool optionalfont;
  final bool inputTextAnimation;
  final bool secondTextAnimation;
  final bool  withAppBar;
  final bool landscape;
  const AppTitle({this.inputText, this.secondText, this.withAppBar, this.inputTextAnimation, this.secondTextAnimation, this.landscape, this.optionalfont});
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder:(context, orientation){
      return  Stack(
        children: <Widget>[
             Positioned(
        top:  landscape==null?(withAppBar==true?(MediaQuery.of(context).size.height)*1/100:(MediaQuery.of(context).size.height)*5.5/100):(orientation== Orientation.landscape?(MediaQuery.of(context).size.height)*15/100:(MediaQuery.of(context).size.height)*5.5/100),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               inputTextAnimation!=false?   AppTypeWriter(textWriter:inputText, textStyle:TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: optionalfont==null?25.0:21,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)): Text(inputText,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),

                secondTextShow()
              ],
            ),
          ),
        ))
  
        ],
      );
     
    });
}

  Widget secondTextShow() {
    if (secondText != null) {
      return Column(
        children: <Widget>[
          secondTextAnimation!=false?
            AppTypeWriter(textWriter:secondText, textStyle:TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700)): Text(secondText,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
      
          SizedBox(
            height: 3.0,
          ),
        ],
      );
    } else {
      return SizedBox(
        height: 1.00,
      );
    }
  }
}

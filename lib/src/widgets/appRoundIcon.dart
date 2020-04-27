import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';

class AppRoundIcon extends StatelessWidget {

   final bool loginScreen;
  AppRoundIcon({this.loginScreen});
 
  @override

  Widget build(BuildContext context) {

      return Positioned(
        top: loginScreen!=null?(MediaQuery.of(context).size.height*2)/100:(MediaQuery.of(context).size.height*5)/100,
        left: (MediaQuery.of(context).size.width / 2) -(((MediaQuery.of(context).size.height*24)/100)/2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container( 
                width:  (MediaQuery.of(context).size.height*24)/100,
                height: (MediaQuery.of(context).size.height*24)/100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("images/logoLogisticMove.gif"))),
              ),
            ],
          ),
        )
        );

  }
}

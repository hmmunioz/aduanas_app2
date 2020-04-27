import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/appCurvedShape.dart';
import 'package:aduanas_app/src/widgets/appRoundIcon.dart';
import 'package:aduanas_app/src/widgets/appSpinner.dart';
import 'package:aduanas_app/src/widgets/appTitle.dart';
import 'package:provider/provider.dart';

class WaitingScreen extends StatefulWidget {
  static const String routeName = "/waitingScreen";

  
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> { 
  
  @override
  Widget build(BuildContext context) {
     final bloc = Provider.of<Bloc>(context);
    return   Stack(
      children: <Widget>[
               Scaffold(
                     resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                CurvedShape(),             
                  AppTitle(
                  inputText: "RCB Logistic",
                   withAppBar: false,
                   inputTextAnimation: true,
                ),
                AppRoundIcon(),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    height: MediaQuery.of(context).size.height/0.5,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                         Image.asset(
          "images/enconstruccion.png",

          fit: BoxFit.cover,
        ),
                        ]  ),
                    )
                   ),
              ],
            )
          ),
      SpinnerLoading(streamDataTransform: bloc.utilsBloc.getSpinnerState), 
      ],
    );
    
 }
}

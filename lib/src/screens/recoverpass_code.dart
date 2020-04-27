import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/appButton.dart';
import 'package:aduanas_app/src/widgets/appCurvedShape.dart';
import 'package:aduanas_app/src/widgets/appRoundIcon.dart';
import 'package:aduanas_app/src/widgets/appSpinner.dart';
import 'package:aduanas_app/src/widgets/appTitle.dart';
import 'package:aduanas_app/src/widgets/appVerificationCode.dart';
import 'package:provider/provider.dart';

class RecoverPassCode extends StatefulWidget {
  static const String routeName = "/recoverpasscode";

  
  @override
  _RecoverPassCodeState createState() => _RecoverPassCodeState();
}

class _RecoverPassCodeState extends State<RecoverPassCode> {
  void validateCode(Bloc bloc, BuildContext context) {
    bloc.recoverCode.validateCode(context);
    /* Navigator.of(context).pushNamed("/changePassword"); */
   /*  bloc.utilsBloc.changeSpinnerState(true);
    bloc.smsService.signIn(context); */
  }
  Widget containerRecover(Bloc bloc, Orientation orientation){
     return      Container(
                     padding: orientation!=Orientation.landscape?EdgeInsets.symmetric(horizontal: 24.0):EdgeInsets.symmetric(horizontal: 20.0),
                    height:orientation!=Orientation.landscape?MediaQuery.of(context).size.height/0.5:((MediaQuery.of(context).size.height)*65)/100,
                     child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                           SizedBox(
                            height: orientation!=Orientation.landscape?MediaQuery.of(context).size.height / 2.88:0.0,
                          ),                                  
                                  Text("Validación contraseña",
                                style: TextStyle(
                                    color:Theme.of(context).accentColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 2.0,
                            ),
                           SizedBox(
                        height: 20.0,
                      ),
                    VerificationCodeInput(
                          keyboardType: TextInputType.number,
                          bloc: bloc,
                          length: 5,
                          focusColors: Theme.of(context).primaryColor,
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),  
                          autofocus: true,
                          onCompleted: (String value) {
                             bloc.recoverCode.changeCodeRecover(value);
                          },
                        ),
                       SizedBox(
                        height: 7.0,
                      ),                     
                      AppButton(
                        streamDataTransform: bloc.recoverCode.getCodeRecover,
                        color:Theme.of(context).primaryColor,
                        name: "ENVIAR",
                        context: context,
                       invertColors: false,
                        onPressed: ()=> validateCode(bloc, context),
                      )
                         ],
                      ),
                    )
                   );          
  }
  
  @override
  Widget build(BuildContext context) {
     final bloc = Provider.of<Bloc>(context);
    return  OrientationBuilder(
        builder: (context, orientation) {
     return  Stack(
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
                   landscape: true,
                ),
             (orientation == Orientation.portrait?AppRoundIcon():SizedBox(height: 1.0,)),
                (orientation == Orientation.portrait?containerRecover(bloc, orientation):Container(
              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height / 2.5),
     /*          height:  100, */
              child: SingleChildScrollView(
              child: containerRecover(bloc, orientation),
            ))
            ) ,
              ],
            )
          ),
      SpinnerLoading(streamDataTransform: bloc.utilsBloc.getSpinnerState), 
      ],
    );});
}
}

import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/appButton.dart';
import 'package:aduanas_app/src/widgets/appCurvedShape.dart';
import 'package:aduanas_app/src/widgets/appRoundIcon.dart';
import 'package:aduanas_app/src/widgets/appSpinner.dart';
import 'package:aduanas_app/src/widgets/appTextField.dart';
import 'package:aduanas_app/src/widgets/appTitle.dart';
import 'package:provider/provider.dart';

class RecoverPassEmail extends StatefulWidget {
  static const String routeName = "/recoverpassemail";
  
  @override
  _RecoverPassEmailState createState() => _RecoverPassEmailState();
}

class _RecoverPassEmailState extends State<RecoverPassEmail> {

  void goToCodeScreen() {
    
    Navigator.pushNamed(context, "/recoverpasscode");
  }
  void addEmailRecoverToSink(String value, Bloc bloc){
   bloc.recoverEmail.changeEmailRecover(value);
  }
  void sendEmail(Bloc bloc, BuildContext context){  
    bloc.recoverEmail.sendEmail(context);
  }
  Widget containerRecover(Bloc bloc, Orientation orientation){
        
    print(MediaQuery.of(context).size.height);
         return Container(
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
                            Text("Recuperar contraseña",
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
                      AppTextField(                 
                        addObsucre: false,
                        inputType: TextInputType.emailAddress,
                        streamDataTransform: bloc.recoverEmail.getEmailRecover,      
                        onChanged: (value)=> addEmailRecoverToSink(value, bloc),             
                        inputText: "CORREO ELECTRONICO",
                        inputIcon: Icon(
                          Icons.alternate_email,
                          color: Theme.of(context).accentColor,
                        ),
                        inputColor: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        height: 7.0,
                      ),
                      AppButton(
                        streamDataTransform: bloc.recoverEmail.getEmailRecover,
                        color:Theme.of(context).primaryColor,
                          invertColors: false,
                          context: context,
                        name: "ENVIAR",
                        onPressed: ()=> sendEmail(bloc, context),
                        /* _con.submit() */
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
                   return     Stack(
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
    );    
  });
 }
}

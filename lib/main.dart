

import 'package:aduanas_app/src/constants/constants.dart';
import 'package:aduanas_app/src/screens/splash_rcb_screen.dart';
import 'package:aduanas_app/src/screens/test_page.dart';
import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/repositories/repository.dart';
import 'package:aduanas_app/src/screens/container_screens.dart';
import 'package:aduanas_app/src/screens/login_screen.dart';
import 'package:aduanas_app/src/screens/recoverpass_code.dart';
import 'package:aduanas_app/src/screens/recoverpass_email.dart';
import 'package:aduanas_app/src/screens/change_password.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
Repository repository = new Repository();
  
 void main() {     
  runApp(Provider<Bloc>(
      create: (context) => Bloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: ConstantsApp(
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                backgroundColor: Color.fromRGBO(255, 143, 52, 1) ,
                  primaryColor: Color.fromRGBO(255, 143, 52, 1),
                  accentColor: Color.fromRGBO(142, 144, 146, 1),
                  canvasColor: Colors.transparent,
                  fontFamily: 'Montserrat',
                  highlightColor: Color.fromRGBO(96, 96, 96, 1) ,
                  focusColor: Color.fromRGBO(255, 143, 52, 1),
                  cursorColor: Color.fromRGBO(255, 143, 52, 1),
                  textSelectionColor: Color.fromRGBO(255, 143, 52, 1),
                  textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
              home: SplashRcbScreen(),
              routes: <String, WidgetBuilder> {
            LoginScreen.routeName: (BuildContext context)  => LoginScreen(),
            RecoverPassEmail.routeName: (BuildContext context) =>   RecoverPassEmail(),
            RecoverPassCode.routeName: (BuildContext context) => RecoverPassCode(),
            ChangePassword.routeName: (BuildContext context) =>   ChangePassword(),  
            SplashRcbScreen.routeName: (BuildContext context)=>    SplashRcbScreen(), 
            TestPage.routeName:(BuildContext context)=> TestPage(),      
            ContainerHome.routeName: (BuildContext context) => ContainerHome(),        
          }
         )
        )
       )
      );
}

class SystemUiOverlayStyle {
}

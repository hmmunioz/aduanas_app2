import 'dart:async';

import 'package:aduanas_app/src/screens/waiting_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:aduanas_app/src/models/password_model.dart';
import 'package:aduanas_app/src/screens/aforos_screen.dart';
import 'package:aduanas_app/src/screens/home_screen.dart';
import 'package:aduanas_app/src/screens/qrscanner_screen.dart';
import 'package:aduanas_app/src/screens/tramites_screen.dart';

class Validators{
  final validateEmail = 
        StreamTransformer<String, String>
        .fromHandlers(
          handleData: (email, sink){
            if(email.contains('@')){
              sink.add(email);
            }else{
              sink.addError("Email invalido");
            }
          }
        );

 final validatePass = 
        StreamTransformer<String, String>
        .fromHandlers(
          handleData: (pass, sink){
            if(pass.length>2){
              sink.add(pass);
            }else{
              sink.addError("Contraseña invalida");
            }
          }
        );

  final validateKeyboardState = 
      StreamTransformer<int, int>
      .fromHandlers(
        handleData: (keyboard, sink){
          print("este es el sink $keyboard");
         if(keyboard!=null){
           sink.add(keyboard);
         }
         else{
           sink.addError(-1);
         }
          
        }
      );

  final validateCodeRecover = 
      StreamTransformer<String, String>
      .fromHandlers(
        handleData: (code, sink){       
         if(code!=null && code.length==5){
   
           sink.add(code);
         }
         else{
           sink.addError(-1);
         }
          
        }
      );
  
  final validateEqualPassword =
  StreamTransformer<PasswordModel,bool>
  .fromHandlers(
          handleData: (modelPassword, sink){  
         if(modelPassword.getNewPassword.length>2 && modelPassword.getNewPassword==modelPassword.getRepeatNewPassword && modelPassword.getRepeatNewPassword!="" && modelPassword.getNewPassword!="" && modelPassword!=null)
         {           
            sink.add(true);
         }
         else{
           sink.addError(false);
         }
          
        }
  );
  final validatePhoneNumber =
  StreamTransformer<String,String>
  .fromHandlers(
          handleData: (phoneNumber, sink){       
            print("data for handlressssss");
         if( phoneNumber.length==10  )
         {           
            sink.add(phoneNumber);
         }
         else{
           sink.addError("Numero incorrecto");
         }
          
        }
  );

  final validateActualScreens =
  StreamTransformer<int,dynamic>
  .fromHandlers(
          handleData: (actualScreen, sink){       
           
        if(actualScreen==0){
         
             sink.add(HomeScreen());
         }
         else if(actualScreen==1)
         {           
            sink.add(TramitesScreen());
         }
         else if(actualScreen==2){
             sink.add(WaitingScreen());
         }
         else if(actualScreen==3){
             sink.add(WaitingScreen());
         }
         else if(actualScreen==4){
             sink.add(WaitingScreen());
         }
         else if(actualScreen==5){
             sink.add(ScanScreen());
         }
         else if(actualScreen==null){
             sink.add(WaitingScreen());
         }         
         else{
           sink.addError("Numero incorrecto");
         }
          
        }
  );

   final validateSpinnerState =
  StreamTransformer<bool,bool>
  .fromHandlers(
          handleData: (showSpinner, sink){       
            print("data for handlressssss");
         if(showSpinner ==true  )
         {           
            sink.add(showSpinner);
         }
         else if(showSpinner==false){
             sink.add(showSpinner);
         }
         else if(showSpinner==null){
           sink.addError(showSpinner);
         }
          
        }
  );
    final validateTramiteObj = 
        StreamTransformer<bool,bool>
        .fromHandlers(
          handleData: (tramiteIsOk, sink){
            if(tramiteIsOk==true){
              sink.add(tramiteIsOk);
            }else{
              sink.addError("No se puedo agregara la lista");
            }
          }
        );

   final validateSearch = 
        StreamTransformer<String,String>
        .fromHandlers(
          handleData: (tramiteIsOk, sink){
            if(tramiteIsOk!=null){
              sink.add(tramiteIsOk);
            }else{
              sink.addError("No se puedo agregara la lista");
            }
          }
        );

   final validateDrawer =
  StreamTransformer<bool,bool>
  .fromHandlers(
          handleData: (changeDrawer, sink){       
            print("data for handlressssss");

         if(changeDrawer ==true  )
         {           
            sink.add(changeDrawer);
         }
         
         else{
           sink.addError(changeDrawer);
         }
          
        }
  );
}
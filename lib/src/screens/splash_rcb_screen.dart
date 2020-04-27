import 'dart:async';
import 'dart:io';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/animations/fancy_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
class SplashRcbScreen extends StatefulWidget {
          
  static const String routeName = "/splashRcbScreen";
    final storage = new FlutterSecureStorage();
  @override
  _SplashRcbScreenState createState() => _SplashRcbScreenState();
}

class _SplashRcbScreenState extends State<SplashRcbScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    final storage = new FlutterSecureStorage();
    String jwtTemp;
  @override
  void initState(){
    
    super.initState();

    redirectHomeOrLogin();
       Timer(Duration(seconds:3), () {
                    if(jwtTemp!=null){
                            Navigator.of(context).pushNamedAndRemoveUntil(
                            "/containerHome",
                            (route) => route.isCurrent && route.settings.name == "/containerHome"
                            ? false
                            : true);
                    }else{
                      Navigator.of(context).pushReplacementNamed("/login");
                    }
                  });      
        PermissionHandler()
        .requestPermissions([PermissionGroup.camera]).then((permisionCamera) {
          print("permiso camera");
          print(permisionCamera[PermissionGroup.camera].value);
      if (permisionCamera[PermissionGroup.camera].value == 2) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.phone]).then((permisionPhone) {
                 print("permiso permisionPhone");
          print(permisionPhone);
          if (permisionPhone[PermissionGroup.phone].value == 2) {
            ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true)
                .then((imei) async {
              await widget.storage.read(key: 'imei') == null
                  ? widget.storage.write(key: 'imei', value: imei)
                  : print("ya existe");   
            });


          } else {
          print("mal email");
           Navigator.pop(context);
          }
        });
      } else {
        print("mal permision");
        Navigator.pop(context);
      }
    });

      }
  
 void redirectHomeOrLogin()async{
       storage.read(key: "jwt").then((jwt){
         if(jwt!=null){
            jwtTemp=jwt;
         }else{
           jwtTemp=null;
         }
       });

   }

  @override
  Widget build(BuildContext context) {
     final bloc = Provider.of<Bloc>(context);
     bloc.initInstanceBlocs(); 
       bloc.tramiteScreen.addIsCompleteLoading(false);
        
      // showNotification();
    return FancyBackgroundDemo();
    }
    
}
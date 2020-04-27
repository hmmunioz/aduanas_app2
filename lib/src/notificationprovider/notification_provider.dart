
import 'dart:typed_data';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/bloc/tramitesscreen/tramiteBloc.dart';
import 'package:aduanas_app/src/constants/constants.dart';
import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
class NotificationProvider{
  int temporalTime=15;
  NotificationProvider._privateConstructor();
  static final NotificationProvider instance = NotificationProvider._privateConstructor();   
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationDetails platformChannelSpecifics;
  void initNotificationProvider(BuildContext context, Bloc bloc){
       var android = new AndroidInitializationSettings("logologistic");
       var iOS = new IOSInitializationSettings();
        var initSettings = new InitializationSettings(android, iOS);  
        flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification:(String payload) async {
    if (payload != null) {
        print('notification payload: ' + payload);
        bloc.containerScreens.changeActualScreen(1);
        Navigator.pushReplacementNamed(context, "/splashRcbScreen");
    }
  });

   var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

   var androidConfig = new AndroidNotificationDetails(ConstantsApp.of(context).appConfig.notificationChannels['id'], ConstantsApp.of(context).appConfig.notificationChannels['name'], ConstantsApp.of(context).appConfig.notificationChannels['description'], 
     color: Theme.of(context).primaryColor,
     enableVibration: true,
     vibrationPattern: vibrationPattern,
     importance: Importance.Max,
      priority: Priority.High,
       enableLights: true,   
        ledColor: Theme.of(context).primaryColor,
        ledOnMs: 1000,
        ledOffMs: 500
   );
     var iOSConfig = new IOSNotificationDetails();
      platformChannelSpecifics = NotificationDetails(
    androidConfig, iOSConfig);
  }


 void deleteNotification(TramiteModel tramiteModel){
/*    flutterLocalNotificationsPlugin.cancel(int.parse(tramiteModel.getNumeroTramite));
   print("Notificacion elminada "+ tramiteModel.getNumeroTramite); */
   
 }

 void showFirebaseNorification(BuildContext context,  String numeroTramite, int type, String title, String body, TramiteBloc tramiteBloc)async{
    /*    await flutterLocalNotificationsPlugin.show(
         int.parse(numeroTramite),   title,  body,  platformChannelSpecifics,   payload: 'Custom_Sound', );
       if(type==1){
         tramiteBloc.refreshTramites(context);
       }else if(type==2){
         tramiteBloc.deleteTramite(context, numeroTramite);
         
       } */

     
 }
void showNotification(BuildContext context,  int type, TramiteModel tramiteModel )async {

  if(tramiteModel.getEstado!=3){
      print("esssssssssssssssssste estel tra");
       
       print(tramiteModel.getFechaExpiracion);
    var tiempoEnvio =DateTime.parse(tramiteModel.getFechaExpiracion).add(Duration(hours: -1));

    Duration difference = DateTime.now().difference(tiempoEnvio);   
    
    var mensaje;
    if(difference.inMicroseconds>=0 ){
        mensaje="El trámite #" + tramiteModel.getNumeroTramite +  " ha caducado";
    }else{
         mensaje="El trámite #" + tramiteModel.getNumeroTramite +  " esta por caducarse";
         print("Este es el timepo de envuoi $tiempoEnvio , y este el mensaje $mensaje");
         await flutterLocalNotificationsPlugin.schedule(
         int.parse(tramiteModel.getNumeroTramite),   mensaje,   'Click aqui, para abrir los tramites.',
         tiempoEnvio,  platformChannelSpecifics,   payload: 'Custom_Sound',   );
    }

  } 
   
}
}

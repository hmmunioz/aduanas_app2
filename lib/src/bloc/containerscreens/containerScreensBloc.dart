import 'package:aduanas_app/src/bloc/tramitesscreen/tramiteBloc.dart';
import 'package:aduanas_app/src/notificationprovider/notification_provider.dart';
import 'package:aduanas_app/src/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ContainerScreensBloc with Validators{  
  NotificationProvider notificationProvider = NotificationProvider.instance;
  TramiteBloc tramiteBloc;
    final _drawerController = BehaviorSubject<bool>(); 
    final _actualScreenController = BehaviorSubject<int>(); ///ContainerScreens
    final _homeScreenController = BehaviorSubject<bool>();
    
    Stream<dynamic> get getActualScreen => _actualScreenController.stream.transform(validateActualScreens); ////Trasnform inData to outData ContainerScreens
    Function(int) get changeActualScreen => _actualScreenController.sink.add;////Set data to block ContainerScreens
    
    Stream<dynamic> get getDrawerTrasnformer => _drawerController.stream.transform(validateDrawer); ////Trasnform inData to outData ContainerScreens
    Function(bool) get changeDrawer => _drawerController.sink.add;

     Stream<dynamic> get getHomeScreenTrasnformer => _homeScreenController.stream.transform(validateDrawer); ////Trasnform inData to outData ContainerScreens
    Function(bool) get changeHomeScreen => _homeScreenController.sink.add;
     
     addNotification(BuildContext context, String numeroTramite, int type, String title, String body)
     {
       notificationProvider.showFirebaseNorification(context, numeroTramite, type, title, body, tramiteBloc);
     }
     //ContainerScreens Methods
      int getDataActualScreen(){
      int actualScreen = _actualScreenController.value;
      return actualScreen;
    }

  
    dispose(){
      _actualScreenController.close();
      _drawerController.close();
      _homeScreenController.close();
    }
}
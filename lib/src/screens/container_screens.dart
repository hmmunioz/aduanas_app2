import 'package:aduanas_app/src/widgets/appAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/models/profile_model.dart';
/* import 'package:aduanas_app/src/repositories/repository.dart'; */
import 'package:aduanas_app/src/screens/aforos_screen.dart';
import 'package:aduanas_app/src/widgets/appSpinner.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ContainerHome extends StatefulWidget {

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    final storage = new FlutterSecureStorage();

  static const String routeName = "/containerHome";
   String token;
     String nombre="";
     ProfileModel profileModel;
   void logOut(Bloc bloc, BuildContext context){
      Navigator.pop(context);
   //   bloc.dispose();
      bloc.login.logOut(context);
   }
     void refreshTramites(Bloc bloc, BuildContext context){
      bloc.tramiteScreen.refreshTramites(context);
   }
   void moreInfoDialog(Bloc bloc, BuildContext context){
     bloc.utilsBloc.openDialog(context, "Informacion de la App", "Version 1.0.0\n\n"+ "Desarrollador\n\n"+ "Mauricio Muñoz", null, true, false);
   }

  void firebaseCloudMessaging_Listeners(BuildContext context, Bloc bloc) {    
    
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      var title= message['data']['title'];
      var body=message['data']['body'];
      var numeroTramite= message['data']['key'].toString();
      var type= message['data']['evento'];
    bloc.containerScreens.addNotification(context, numeroTramite, int.parse(type), title, body);
      print('on message $message');
    },
    onResume: (Map<String, dynamic> message) async {
      var title= message['data']['title'];
      var body=message['data']['body'];
      var numeroTramite= message['data']['key'].toString();
      var type= message['data']['evento'];
      bloc.containerScreens.addNotification(context, numeroTramite, int.parse(type), title, body);
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      var title= message['data']['title'];
      var body=message['data']['body'];
      var numeroTramite= message['data']['key'].toString();
      var type= message['data']['evento'];
      bloc.containerScreens.addNotification(context, numeroTramite, int.parse(type), title, body);
      print('on launch $message');
    },
  );
}

        ContainerHome({this.token, this.profileModel});

  @override
  _ContainerHomeState createState() => _ContainerHomeState();
}

class _ContainerHomeState extends State<ContainerHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  
  }

  void iniToken(BuildContext context, Bloc bloc)async{ 
     widget.firebaseCloudMessaging_Listeners(context ,bloc);
    bloc.utilsBloc.changeSpinnerState(false);  
        ProfileModel p = await bloc.login.addProfileData();        
       widget.profileModel = p;   
     }

  Future<bool> navigationBack(Bloc bloc, BuildContext context){

       if(bloc.containerScreens.getDataActualScreen()==0){
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        else if(bloc.containerScreens.getDataActualScreen()==5){       
          bloc.containerScreens.changeActualScreen(1);
        }
        else if(bloc.containerScreens.getDataActualScreen()==1){

            bloc.tramiteScreen.addIsCompleteLoading(false);
            //Navigator.pushNamed(context, "/containerHome");
            bloc.containerScreens.changeActualScreen(0);
        }
        else{
         // Navigator.pushNamed(context, "/containerHome");
          bloc.containerScreens.changeActualScreen(0);
        }
  }



  Widget build(BuildContext context) {    
 
  WidgetsFlutterBinding.ensureInitialized();
   final bloc = Provider.of<Bloc>(context);  
   //bloc.disposeLogin();    
   iniToken(context, bloc);    
   if(bloc.containerScreens.getDataActualScreen()!=0){
        bloc.containerScreens.changeActualScreen(0);    
    }   
    return WillPopScope(
      onWillPop: () => navigationBack(bloc, context),
 
      child:Stack(
      children: <Widget>[          
        StreamBuilder(
          stream: bloc.containerScreens.getActualScreen,
          builder: (context, snapshot) {
            
            return    Scaffold(
           backgroundColor: Colors.white,
      appBar: bloc.containerScreens.getDataActualScreen()==1?AppappBar():PreferredSize(
          preferredSize: Size.fromHeight(40.0), // here the desired height
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
          )),
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: getDrawer(bloc)),
      
      body: StreamBuilder(
          stream: bloc.containerScreens.getActualScreen,
          builder: (context, snapshot) {
            return getWidgetActualScreen(bloc, snapshot);
          })!=null ?  StreamBuilder(
          stream: bloc.containerScreens.getActualScreen,
          builder: (context, snapshot) {
            return getWidgetActualScreen(bloc, snapshot);
          }) :  AforosScreen() 
       );
     
          }),
        SpinnerLoading(streamDataTransform: bloc.utilsBloc.getSpinnerState),       
      ],
    )
    ); 
 }
  Widget getWidgetActualScreen(Bloc bloc, AsyncSnapshot<dynamic> snapshot){   
     return snapshot.data;
  }
  StreamBuilder getDrawer(Bloc bloc) {
    return  StreamBuilder(
          stream: bloc.containerScreens.getDrawerTrasnformer,
          builder: (context, snapshot) {
            return Drawer(
                  child: getListDrawer(bloc),
                );
          });  
  }

  ListTile getItem(Icon icon, String description, String route, int actualScreen, Bloc bloc) {
    return ListTile(
      leading: icon, 
      title: Text(
        description,
        style: TextStyle(color: Theme.of(context).highlightColor),
      ),
      onTap: () {
        Navigator.pop(context);
        bloc.containerScreens.changeActualScreen(actualScreen);
      },
    );
  }

  ListTile getItemAccion(Icon icon, String description) {
    return ListTile(
      leading: icon,
      title: Text(
        description,
        style: TextStyle(color: Theme.of(context).highlightColor),
      ),
    );
  }

  ListView getListDrawer(Bloc bloc) {
        print("leeeeeeeeeeeeeeeeeeeeeng");

    var initials = widget.profileModel.getNombre.split(' ').length>=2?
              (widget.profileModel.getNombre.split(' ')[0].substring(0,1).toUpperCase() + " " +widget.profileModel.getNombre.split(' ')[1].substring(0,1).toUpperCase()) 
              : 
              (widget.profileModel.getNombre!=null?
                (widget.profileModel.getNombre.substring(0,1).toUpperCase() + " " +widget.profileModel.getNombre.substring(1,2).toUpperCase()) 
                 :
                "");
     
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            widget.profileModel.getNombre ,
            style: TextStyle(color: Colors.white),
          ),
          accountEmail: Text(
            widget.profileModel.getCorreo,        
            style: TextStyle(color: Colors.white),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
               initials,
              style: TextStyle(color: Theme.of(context).highlightColor),
            ),
          ),
        ),
        getItem(Icon(Icons.home, color: Theme.of(context).highlightColor,), "Inicio", "/home", 0, bloc),
        getItem(Icon(Icons.description, color: Theme.of(context).highlightColor,), "Tramites", "/tramites", 1, bloc),
        getItem(Icon(Icons.group, color: Theme.of(context).highlightColor,), "Aforos", "/aforos", 2, bloc),
        getItem(Icon(Icons.folder_special, color: Theme.of(context).highlightColor,), "Archivo", "/archivos", 3, bloc),
        getItem(Icon(Icons.pie_chart, color: Theme.of(context).highlightColor, ), "Reporteria", "/reportes", 4, bloc),
        SizedBox(
          height: 20.0,
        ),
        Divider(),
         GestureDetector(
          onTap: () => widget.refreshTramites( bloc,  context),
          child:    getItemAccion(Icon(Icons.refresh, color: Theme.of(context).highlightColor,), "Actualizar"),
        ),  
     GestureDetector(
          onTap: () => widget.moreInfoDialog( bloc,  context),
          child:   getItemAccion(Icon(Icons.info, color: Theme.of(context).highlightColor,), "Más Información"),
        ),   
    
        GestureDetector(
          onTap: () => widget.logOut( bloc,  context),
          child:   getItemAccion(Icon(Icons.exit_to_app, color: Theme.of(context).highlightColor,), "Salir"),
        ),      
      ],
    );
  }
}

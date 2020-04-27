
import 'package:aduanas_app/src/widgets/appMenuAnimation.dart';
import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/appCurvedShape.dart';
import 'package:aduanas_app/src/widgets/appRoundIcon.dart';
import 'package:aduanas_app/src/widgets/appTitle.dart';
import 'package:provider/provider.dart';
import 'package:aduanas_app/src/models/profile_model.dart';
class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  ProfileModel profileModel;
  String nombre="";
  @override
  _HomeScreenState createState() => _HomeScreenState();
    HomeScreen({ this.profileModel, this.nombre});
}
 

class _HomeScreenState extends State<HomeScreen> {
  void changeActualScreen(Bloc bloc, int actualScreen, BuildContext context){ 
  
     if(bloc.containerScreens.getDataActualScreen()!=actualScreen){
        bloc.containerScreens.changeActualScreen(actualScreen); 
     }
      
  }

  Widget appTitleData(String nombreTemp){
    return  AppTitle(
                    inputText:  "Bienvenido a RCB Logistics",
                    secondText: "¿Qué trámites realizaremos hoy?",
                     withAppBar: true,
                     inputTextAnimation: false,
                     secondTextAnimation: true,
                   );
  }
  
  @override
  Widget build(BuildContext context) {
  
    void initProfile(Bloc bloc) async{
      ProfileModel p = await bloc.login.addProfileData();
      widget.profileModel = p;     
      widget.nombre=widget.profileModel.getNombre;
     bloc.containerScreens.changeHomeScreen(true);      
    }

    WidgetsFlutterBinding.ensureInitialized();
    final bloc = Provider.of<Bloc>(context);  
    initProfile(bloc);
    return  StreamBuilder(
    stream: bloc.containerScreens.getHomeScreenTrasnformer, 
    builder: (context, snapshoot){
      return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                CurvedShape(),
                appTitleData(widget.nombre),
                SizedBox(height: 25.0,),
               AppRoundIcon(),     
                Container(                
                    height: MediaQuery.of(context).size.height/0.5,           
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.70,
                          ),
                          AppMenuAnimation(),
                      ],
                      ),
                   ),
              ],
            )
          );
   
    });
      
  }
}

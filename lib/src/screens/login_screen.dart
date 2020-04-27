import 'package:aduanas_app/src/widgets/appCurvedShape.dart';
import 'package:aduanas_app/src/widgets/appRoundIcon.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/models/profile_model.dart';
import 'package:aduanas_app/src/widgets/appButton.dart';
import 'package:aduanas_app/src/widgets/appSpinner.dart';
import 'package:aduanas_app/src/widgets/appTextField.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart'; 
import 'dart:io';
class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";
  String token;
  String platformImeI;
  ProfileModel profileModel;
  final storage = new FlutterSecureStorage();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  LoginScreen({this.profileModel}): super();
  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

    final storage = new FlutterSecureStorage();

class _LoginScreenState extends State<LoginScreen> {
    VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'videos/fondo.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }
  void iOS_Permission() {
  widget._firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
  );
  widget._firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings)
  {
    print("Settings registered: $settings");
  });
}
  void initPhoneCredentials(BuildContext context) async {
  if (Platform.isIOS) iOS_Permission();
                          widget._firebaseMessaging.getToken().then((token){
                            print("esteeeeeee eeeeees el tooookoeeeeeen");
                            storage.write(key: 'firebaseToken', value: token);
                            print(token);
                          });



  }

  void login(Bloc bloc, BuildContext context) {
    bloc.login.login(okLogin, context);
  }

  void onChangedEmail(value, Bloc bloc) {
    bloc.login.changeEmail(value);
  }

  void onChangedPass(value, Bloc bloc) {
    bloc.login.changePass(value);
  }

  void okLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        "/containerHome",
        (route) => route.isCurrent && route.settings.name == "/containerHome"
            ? true
            : false); 
  }

  void failed() {
    print("failed");
  }

  Widget containerRecover(Bloc bloc, Orientation orientation) {
    return Container(
        padding: orientation != Orientation.landscape
            ? EdgeInsets.symmetric(horizontal: 24.0)
            : EdgeInsets.symmetric(horizontal: 20.0),
        height: orientation != Orientation.landscape
            ? MediaQuery.of(context).size.height / 0.5
            : ((MediaQuery.of(context).size.height) * 65) / 100,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
               SizedBox(
                        height:((MediaQuery.of(context).size.height) * 30) / 100,
                      ),
               Text("Bienvenidos a RCB Logistic", style: TextStyle( fontSize: orientation==Orientation.portrait? 20.0:25.0, fontWeight: FontWeight.w700)),
                SizedBox(height: 20.0,),
              AppTextField(
                  addObsucre: false,
                  streamDataTransform: bloc.login.getEmail,
                  onChanged: (value) => onChangedEmail(value, bloc),
                  inputType: TextInputType.emailAddress,
                  inputText: "USUARIO",
                  inputIcon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  inputColor: Colors.white),
              SizedBox(
                height: 7.0,
              ),
              AppTextField(
                  streamDataTransform: bloc.login.getPass,
                  onChanged: (value) => onChangedPass(value, bloc),
                  inputType: TextInputType.visiblePassword,
                  addObsucre: true,
                  inputText: "PASSWORD",
                  inputIcon: Icon(
                    Icons.lock_open,
                    color: Colors.white,
                  ),
                  inputColor: Colors.white),
              SizedBox(
                height: 5.0,
              ),
              AppButton(
                streamDataTransform: bloc.login.submitValid,
                color: Theme.of(context).primaryColor,
                name: "INGRESAR",
                context: context,
                invertColors: false,
                onPressed: () {
                  login(bloc, context);
                },
              ),
              Center(
                  child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/recoverpassemail");
                },
                child: Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ))
            ])));
  }
  Future<bool> navigationBack(Bloc bloc, BuildContext context){
   SystemChannels.platform.invokeMethod('SystemNavigator.pop');      
  }

  @override
  Widget build(BuildContext context) {
    initPhoneCredentials(context);
    void iniToken(BuildContext context, Bloc bloc) async {
      widget.profileModel = bloc.login.getDataProfile();
      widget.token = await widget.storage.read(key: 'jwt');
      if (widget.token != null && widget.token != "") {
        bloc.utilsBloc.changeSpinnerState(false);
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/containerHome",
            (route) =>
                route.isCurrent && route.settings.name == "/containerHome"
                    ? false
                    : true);
      } else {
        bloc.utilsBloc.changeSpinnerState(false);
      }
    }

    WidgetsFlutterBinding.ensureInitialized();

    final bloc = Provider.of<Bloc>(context);
    iniToken(context, bloc);

    return WillPopScope(
      onWillPop: () => navigationBack(bloc, context),
 
      child:
     OrientationBuilder(builder: (context, orientation) {
      return Stack(children: <Widget>[
  
           SizedBox.expand(            
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size?.width ?? 0,
                  height: _controller.value.size?.height ?? 0,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
        /*   ), */
     
        Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                 CurvedShape(transparent:true),
                  SizedBox(
                        height: 10.0,
                      ),

                (orientation == Orientation.portrait
                    ? AppRoundIcon(loginScreen: true)
                    : SizedBox(
                        height: 1.0,
                      )),
                (orientation == Orientation.portrait
                    ? containerRecover(bloc, orientation)
                    : Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 4),
                        child: SingleChildScrollView(
                          child: containerRecover(bloc, orientation),
                        ))),
              ],
            )

            ),
        SpinnerLoading(streamDataTransform: bloc.utilsBloc.getSpinnerState),
      ]);
    })
    );
  }
    @override
  void dispose() {
    super.dispose();
  /*   _controller.dispose(); */
  }
}

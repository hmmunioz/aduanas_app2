import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/widgets/appRoundCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';



class Box extends StatelessWidget {
  static final boxDecoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(10)),
 );
void changeActualScreen(Bloc bloc, int actualScreen, BuildContext context){ 
    if(actualScreen==4){
 
    }
     if(bloc.containerScreens.getDataActualScreen()!=actualScreen){
        bloc.containerScreens.changeActualScreen(actualScreen); 
     }
      
  }      
Widget menuGrid(BuildContext context, Bloc bloc){
   return  GridView.count(
                            primary: false,
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 0.2,
                            crossAxisSpacing: 1.0,
                            children: <Widget>[
                              AppRoundCard(
                                  onClick:()=> changeActualScreen(bloc, 1, context),
                                  inputText: "Tramites",
                                  iconCard: Icons.description,
                                  inputColor:Theme.of(context).highlightColor),
                              AppRoundCard(
                                  onClick:()=> changeActualScreen(bloc, 2, context),
                                  inputText: "Aforos",
                                  iconCard: Icons.group,
                                  inputColor:Theme.of(context).highlightColor),
                              AppRoundCard(
                                  onClick:()=> changeActualScreen(bloc,3, context),
                                  inputText: "Archivos",
                                  iconCard: Icons.folder_special,
                                  inputColor:Theme.of(context).highlightColor),
                              AppRoundCard(
                                  onClick:()=> changeActualScreen(bloc, 4, context),
                                  inputText: "Reporteria",
                                  iconCard: Icons.pie_chart,
                                  inputColor: Theme.of(context).highlightColor),
                            ],
                            shrinkWrap: true,
                          );
}
  @override
  Widget build(BuildContext context) {
     final bloc = Provider.of<Bloc>(context);  
    return ControlledAnimation(
      duration: Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 80.0),
      builder: (context, height) {
        return ControlledAnimation(
          duration: Duration(milliseconds: 1200),
          delay: Duration(milliseconds: 500),
          tween: Tween(begin: 2.0, end: 300.0),
          builder: (context, width) {
            return 
            Center( child:           Container(
              decoration: boxDecoration,
              width: width,
              height: MediaQuery.of(context).size.height/2,
              child: isEnoughRoomForTypewriter(width)
                  ? menuGrid(context, bloc)
                  : Container(),
            ),
          );
         },
        );
      },
    );
  }

  isEnoughRoomForTypewriter(width) => width > 20;
}

class TypewriterText extends StatelessWidget {
  static const TEXT_STYLE =
      TextStyle(letterSpacing: 5, fontSize: 20, fontWeight: FontWeight.w300);

  final String text;
  TypewriterText(this.text);

  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
        duration: Duration(milliseconds: 800),
        delay: Duration(milliseconds: 800),
        tween: IntTween(begin: 0, end: text.length),
        builder: (context, textLength) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text.substring(0, textLength), style: TEXT_STYLE),
              ControlledAnimation(
                playback: Playback.LOOP,
                duration: Duration(milliseconds: 600),
                tween: IntTween(begin: 0, end: 1),
                builder: (context, oneOrZero) {
                  return Opacity(
                      opacity: oneOrZero == 1 ? 1.0 : 0.0,
                      child: Text("_", style: TEXT_STYLE));
                },
              )
            ],
          );
        });
  }
}

class AppMenuAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,  
      child:  Center(child: Box()),     
    );       

  }
}

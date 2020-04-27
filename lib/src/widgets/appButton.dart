import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final String name;
  final bool invertColors;
  final BuildContext context;
  final Stream<dynamic> streamDataTransform;
  const AppButton({this.color, this.onPressed, this.name, this.streamDataTransform, this.invertColors, this.context});
 
 Widget getButtonAction(VoidCallback onPressedMetod){
     return InkWell(
         onTap: onPressedMetod!=null ? onPressedMetod :null,
         child:   Padding(
      padding: EdgeInsets.symmetric(vertical: 13.0),
      child: Material(
          borderRadius: BorderRadius.circular(30.0),
         
          color: invertColors ? Colors.white : color,
          elevation: 5.0,
          child: SizedBox(
          width: (MediaQuery.of(context).size.width*89)/100,
            height: 43.0,
            child: FlatButton(
              
              child: Text(name,
                  style: TextStyle(fontSize: 18.0, color: invertColors ? color :Colors.white)),
              onPressed: null,
            ),
          )),
      ),
       );
 }
  Widget getButtonApp(AsyncSnapshot<dynamic> snapshot) 
  {
    if(snapshot!=null){
      if(snapshot.hasData){
        return getButtonAction(onPressed);
      }
      else{
       return getButtonAction(null);
      }            
    }
    else{
       return getButtonAction(onPressed);
     }
  }

  @override
  Widget build(BuildContext context) {
    if (streamDataTransform != null) {
      return StreamBuilder(
          stream: streamDataTransform,
          builder: (context, snapshot) {
            return getButtonApp(snapshot);
          });
    } else {
      return getButtonApp(null);
    }
  }
}

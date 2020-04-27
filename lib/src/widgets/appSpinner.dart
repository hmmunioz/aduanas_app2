import 'package:aduanas_app/src/widgets/appTypewriterBox.dart';
import 'package:flutter/material.dart';
class SpinnerLoading extends StatefulWidget {
  @override
  _SpinnerLoadingState createState() => _SpinnerLoadingState();
  final Stream<dynamic> streamDataTransform;
  SpinnerLoading({this.streamDataTransform});
}

class _SpinnerLoadingState extends State<SpinnerLoading> {
  Widget toggleSpinner(AsyncSnapshot snapshot){
    if(snapshot.data==true){
         FocusScope.of(context).requestFocus(new FocusNode());
      print("opeeeen spinner");
      return Positioned(child:Container(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      child: Center(
       child: Column(
         mainAxisAlignment:MainAxisAlignment.center,
         children: <Widget>[          
           Image.asset(
          "images/logoFlecha.gif",
          height: (MediaQuery.of(context).size.height*24)/100,
          width: (MediaQuery.of(context).size.height*24)/100,
          ),
          AppTypeWriter(textWriter: "Cargando", textStyle: TextStyle(decoration: TextDecoration.none, color:Colors.white)),
         ],
       ),
     ),
    )
   );
       }
    else{
       print("close spinner");
      return SizedBox(height: 0.0,);
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
      stream: widget.streamDataTransform,
      builder:  (context, snapshot) {
            return toggleSpinner(snapshot);
          }
    );
  }
}
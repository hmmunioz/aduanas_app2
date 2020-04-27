import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:qr_flutter/qr_flutter.dart';
class TramiteDetail extends StatefulWidget {
  static const String routeName = "/tramiteDetail";
  @override
  _TramiteDetailState createState() => _TramiteDetailState();
}
   
  Future<bool> navigationBack(Bloc bloc, BuildContext context){

      if(bloc.containerScreens.getDataActualScreen()==5){       
        Navigator.pop(context);
          bloc.containerScreens.changeActualScreen(1);
        }
        else{
          Navigator.pop(context);
        }
     
  }

class _TramiteDetailState extends State<TramiteDetail> {
  @override
  Widget build(BuildContext context) {    
    final bloc = Provider.of<Bloc>(context);
    TramiteModel tramiteModel = bloc.tramiteScreen.getValueTramiteDetail();
     String initials =tramiteModel.getResponsable.split(' ').length>=2?
              (tramiteModel.getResponsable.split(' ')[0].substring(0,1).toUpperCase() + " " +tramiteModel.getResponsable.split(' ')[1].substring(0,1).toUpperCase()) 
              : 
              (tramiteModel.getResponsable!=null?
                (tramiteModel.getResponsable.substring(0,1).toUpperCase() + " " +tramiteModel.getResponsable.substring(1,2).toUpperCase()) 
                 :
                "");
  
      String fecha =  tramiteModel.getFechaExpiracion.split("T")[0]!=null? tramiteModel.getFechaExpiracion.split("T")[0]+" "+tramiteModel.getFechaExpiracion.split("T")[1]:tramiteModel.getFechaExpiracion;
    return  WillPopScope(
      onWillPop: () => navigationBack(bloc, context),
    child:
     Scaffold(   
      body: StreamBuilder(     
        initialData: false,
        stream: slimyCard.stream, 
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(height: 200),
              SlimyCard(
                color: Theme.of(context).accentColor,            
                topCardWidget: topCardWidget(tramiteModel, initials),
                bottomCardWidget: bottomCardWidget(tramiteModel, fecha),
              ),
            ],
          );
        }),
      ),
    )
   );
  }
    Widget topCardWidget(TramiteModel tramiteModel, String initials) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
         Text(
          "Tramite #"+ tramiteModel.getNumeroTramite,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),            
       SizedBox(height: 10),
       CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
               initials,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
        ),
        SizedBox(height: 5),
        Text(
          tramiteModel.getResponsable,
          style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
                      QrImage(
                foregroundColor: Colors.white,
                data: tramiteModel.getNumeroTramite,
                version: QrVersions.auto,
                size:(MediaQuery.of(context).size.height*16)/100 ,
              ),
              ],
    );
  }

  // This widget will be passed as Bottom Card's Widget.
  Widget bottomCardWidget(TramiteModel tramiteModel, String fecha) {
    return Column(
      children: <Widget>[
         Text(
          "Cliente",
          style: TextStyle(color: Colors.white, fontSize: 21),
        ),   
         Text(
        tramiteModel.getCliente,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
 /*        fontWeight: FontWeight.w500, */
      ),
      textAlign: TextAlign.center,
       ),
       
        Text(
      'Fecha: '+ fecha,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
       
      ),
      textAlign: TextAlign.center,
    ),
    Text(
          "Actividad",
          style: TextStyle(color:  Colors.white, fontSize: 19, ),
     ), 
     Text(
       tramiteModel.getActividad,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
    
      ),
      textAlign: TextAlign.center,
    )
      ],
    );  
  }
}

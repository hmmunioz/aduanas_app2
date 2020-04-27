import 'dart:async';
import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/constants/constants.dart';
import 'package:aduanas_app/src/notificationprovider/notification_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:http/http.dart' show Client, Response;
import 'dart:convert';

import 'package:provider/provider.dart';

class TramiteApiProvider {
  static final TramiteApiProvider _tramiteApiProvider = new TramiteApiProvider();
  
    static TramiteApiProvider get(){
    return _tramiteApiProvider;
  }
  NotificationProvider notificationProvider = NotificationProvider.instance;
  Client client = Client();
  final storage = new FlutterSecureStorage();
  final List<TramiteModel> _porRecibir = [];
  final List<TramiteModel> _recibidos = [];
  final List<TramiteModel> _entregados = [];
  Map<String, String> headers = {"Content-type":"application/json ; charset=utf-8"};

 void sendNotificationTramite(){

 } 
 Future<bool> changeTramite(String tramiteId, int estado,  UtilsBloc utilsbloc, BuildContext context) async {
   if(estado<3){
     estado++;
   }
   dynamic objPostChangeTramite ={"id":tramiteId, "estado": estado }; 
    String urlApi= ConstantsApp.of(context).appConfig.base_url + ConstantsApp.of(context).urlServices.tramites['changeTramiteStatus'];  
   final response = await client.put("$urlApi", headers:headers, body:json.encode(objPostChangeTramite) )
    .timeout( Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout :(){
      utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false );
   });
   print("resposneeeeeeeeeeeeeeeeerer");
   print(response.statusCode);
   if (response.statusCode == 200) 
    {      
      if(json.decode(response.body)["exito"]==true)
      {
          return true;
      }
      else{
        utilsbloc.changeSpinnerState(false);     
        utilsbloc.openDialog(context, "Ha ocurrido un error", "No se ha podido cambiar el tramite", null,  true, false );
        return false;
      }
    }else{
      utilsbloc.changeSpinnerState(false);
       utilsbloc.openDialog(context, "Ha ocurrido un error.", "No se ha podido cambiar el tramite", null,  true, false );
       
        print(response.statusCode.toString());
        print(response.body.toString());
        
      
      return false;
    } 
   }  
 
  sendNotification(BuildContext context, dynamic tr, List<TramiteModel>  notificationList ){
    notificationProvider.showNotification(context, 0, new TramiteModel.fromJson(tr)); 
     notificationList.add(new TramiteModel.fromJson(tr));
  }


  Future<dynamic> getTramites(BuildContext context, UtilsBloc utilsbloc) async { 
    final bloc = Provider.of<Bloc>(context);
   notificationProvider.initNotificationProvider(context, bloc);
     dynamic objPostGetTramites ={"usuarioId":await storage.read(key: 'jwt'), "fechaUltimSincronisacion":await storage.read(key: 'fechaSincroniza')!=null?await storage.read(key: 'fechaSincroniza'):""};       
     String urlApi= ConstantsApp.of(context).appConfig.base_url + ConstantsApp.of(context).urlServices.tramites['getAll'];  
   
    final response = await client.post("$urlApi", headers:headers, body:json.encode(objPostGetTramites) /* objPostGetTramites.toString() */)
    .timeout( Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout :(){
      utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false );
   });
    String utf8Body = Utf8Decoder().convert(response.bodyBytes);
print("respuesta de tramites");
print(response.statusCode);
    if (response.statusCode == 200) 
    {       
      print(json.decode(utf8Body));
  print("traaamiteeees 2000");
       _porRecibir.clear();
       _recibidos.clear();
       _entregados.clear();
      json.decode(utf8Body)/* [0] */["asignados"]
          .map((tr) => !_porRecibir.contains(new TramiteModel.fromJson(tr))? sendNotification(context, tr, _porRecibir) :print("Ya existe"))
          .toList();
   
      json.decode(utf8Body)/* [0] */["recibidos"]
          .map((tr) =>!_recibidos.contains(new TramiteModel.fromJson(tr))?sendNotification(context, tr, _recibidos)  :print("Ya existe"))
          .toList();
     
      json.decode(utf8Body)/* [0] */["entregados"]
          .map((tr) =>!_entregados.contains(new TramiteModel.fromJson(tr))?sendNotification(context, tr, _entregados) :print("Ya existe"))
          .toList(); 
          
     (json.decode(utf8Body)/* [0] */["fechaSincroniza"]!=""&& json.decode(utf8Body)["fechaSincroniza"]!=null)
     ? storage.write(key: 'fechaSincroniza', value: json.decode(utf8Body)["fechaSincroniza"].toString().split(' ')[0]+"T"+json.decode(utf8Body)["fechaSincroniza"].toString().split(' ')[1])
      :print("fechaVacia");
  
      dynamic responseData = {
        'porRecibir': _porRecibir,
        'recibidos': _recibidos,
        'entregados': _entregados
      };

      return responseData;
    } else {
        utilsbloc.changeSpinnerState(false);
        print(response.statusCode.toString());
        print(utf8Body.toString());
   
    return null;
    } 
     }
}

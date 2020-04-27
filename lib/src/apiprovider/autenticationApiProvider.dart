import 'dart:async';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';

class AutenticationApiProvider {
  
  static final AutenticationApiProvider _autenticationApiProvider = new AutenticationApiProvider();
  static AutenticationApiProvider get(){
    return _autenticationApiProvider;
  }
  final storage = new FlutterSecureStorage();
  Client client = Client();    
  Map<String, String> headers = {"Content-type":"application/json; charset=utf-8"};  

  Future<dynamic> login(String username, String password, UtilsBloc utilsbloc, BuildContext context) async {
  utilsbloc.changeSpinnerState(true);
 try {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
   dynamic objPostLogin ={"username":username, "password": password, }; 
   String urlApi= ConstantsApp.of(context).appConfig.base_url + ConstantsApp.of(context).urlServices.autentication['login']; 

   final response = await client.post("$urlApi", headers:headers, body:json.encode(objPostLogin) ).timeout( Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout :(){
      utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false );
   });
    String utf8Body = Utf8Decoder().convert(response.bodyBytes);
   print("get phomneeee dataaaaaaaaaaaaa");
      print(objPostLogin);
      print(json.decode(utf8Body));

   if (response.statusCode == 200) 
    {    
      if(json.decode(utf8Body)/* [0] */['estado']==true){   
         storage.write(key: 'jwtTemp', value:json.decode(utf8Body)/* [0] */['usuarioUUID'] );   
        return json.decode(utf8Body);  
      }
      else{
        utilsbloc.changeSpinnerState(false);
        return null;
       }
    }
    else{
         utilsbloc.changeSpinnerState(false);
        print(response.statusCode.toString());
      print(utf8Body.toString());
        
    return null;
    } 

  }
} on SocketException catch (_) {
     utilsbloc.changeSpinnerState(false);
  utilsbloc.openDialog(context, "Error de red", "No tiene conexión a Internet", (){   utilsbloc.changeSpinnerState(false);}, true, false);

}
 
 
 
  // final bloc = Provider.of<Bloc>(context);
  
   }  


   Future<dynamic> getPhoneData( UtilsBloc utilsbloc, BuildContext context) async {   
        utilsbloc.changeSpinnerState(true);
try{ 
   dynamic objPostPhoneData ={"usuarioUUID": await storage.read(key: 'jwtTemp'), "imei":  await storage.read(key: 'imei'), "token": await storage.read(key: 'firebaseToken') }; 
   String urlApi= ConstantsApp.of(context).appConfig.base_url + ConstantsApp.of(context).urlServices.autentication['getPhoneData']; 
   final response = await client.post("$urlApi", headers:headers, body:json.encode(objPostPhoneData)).timeout( Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout :(){
      utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false );
   });
   
   print("get phomneeee dataaaaaaaaaaaaa");
      print(objPostPhoneData);
      print(response.statusCode);
   print(json.decode(response.body));

   if (response.statusCode == 200) 
    {  
      if(json.decode(response.body)['estado']==true){
         storage.write(key: 'jwt', value: await storage.read(key: 'jwtTemp'));     
         storage.delete(key: "jwtTemp");
        /* storage.delete(key: "imei"); */
        storage.delete(key: "firebaseToken");
        await storage.read(key: "code")!=null?storage.delete(key: "code"):print("no hay code");
         return  json.decode(response.body)/* [0] */!=null?json.decode(response.body)/* [0] */:(){  storage.delete(key: 'jwt');return null;}  ;        
      }
      else{
         storage.delete(key: 'jwt');
         utilsbloc.changeSpinnerState(false);
        return null;
      }
       }
    else{
      storage.delete(key: 'jwt');
    utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor", (){utilsbloc.changeSpinnerState(false);},  true, false );
        print(response.statusCode.toString());
        print(response.body.toString());
          utilsbloc.changeSpinnerState(false);
      return null;
    } 
    } on SocketException catch (_) {
        utilsbloc.changeSpinnerState(false);
  utilsbloc.openDialog(context, "Error de red", "No tiene conexión a Internet", (){   utilsbloc.changeSpinnerState(false);}, true, false);

}
   }  

   Future<dynamic> sendEmail( UtilsBloc utilsbloc, BuildContext context, String email) async { 
   try{
   utilsbloc.changeSpinnerState(true);
   dynamic objPostSendEmail ={"correo": email }; 
   String urlApi= ConstantsApp.of(context).appConfig.base_url + ConstantsApp.of(context).urlServices.autentication['sendEmail']; 
   final response = await client.post("$urlApi", headers:headers, body:json.encode(objPostSendEmail)).timeout( Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout :(){
      utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false );
   });
   print("sendemaiil");
   print(json.decode(response.body));
       print(response.statusCode);
   if (response.statusCode == 200) {
    print(json.decode(response.body)); 
     if( json.decode(response.body)/* [0] */!=null&& json.decode(response.body)/* [0] */['estado']==true )
        {
           utilsbloc.openDialog(context, "Correo enviado", "Se ha enviado un código de validacion a su correo.", ()=>{Navigator.pushNamed(context, "/recoverpasscode")},  true, false );
        }
        else{
        if(json.decode(response.body)/* [0] */['mensaje']=="enviado"){
                utilsbloc.openDialog(context, "Correo no enviado", "Este usuario ya ha recibido un código de validación",  ()=>{Navigator.pushNamed(context, "/recoverpasscode")},  true, false );
            }
              else{          
                utilsbloc.openDialog(context, "Correo no enviado", "El correo es invalido.", null,  true, false );
              }         
        }  
    }
    else{
      utilsbloc.changeSpinnerState(false);
      utilsbloc.openDialog(context, "El correo es invalido", response.body.toString(), null,  true, false );
      return null;
    } 
    } on SocketException catch (_) {
  utilsbloc.openDialog(context, "Error de red", "No tiene conexión a Internet", (){   utilsbloc.changeSpinnerState(false);}, true, false);

}
   }   


    Future<dynamic> validateCode( UtilsBloc utilsbloc, BuildContext context, String correo,String code) async {   
  try{ 
   utilsbloc.changeSpinnerState(true);
   dynamic objPostValidateCode ={"token": code, "correo":correo }; 
   String urlApi= ConstantsApp.of(context).appConfig.base_url + ConstantsApp.of(context).urlServices.autentication['validateCode']; 
   final response = await client.post("$urlApi", headers:headers, body:json.encode(objPostValidateCode)).timeout( Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout :(){
      utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false );
   });
   if (response.statusCode == 200) 
    {   
        utilsbloc.changeSpinnerState(false);
        if(json.decode(response.body)/* [0] */['estado']==true )
        {
            storage.write(key: 'code', value: code);
            Navigator.pushNamed(context, "/changePassword");
        }
        else{
           utilsbloc.openDialog(context, "Validacion de código", "El código ha expirado o es incorrecto.", null,  true, false );            
       }
    }
    else{
      utilsbloc.changeSpinnerState(false);
      utilsbloc.openDialog(context, "El correo es invalido", response.body.toString(), null,  true, false );
      return null;
    } 
    } on SocketException catch (_) {
  utilsbloc.openDialog(context, "Error de red", "No tiene conexión a Internet", (){   utilsbloc.changeSpinnerState(false);}, true, false);

}
   }   


   Future<dynamic> sendNewCredentials( UtilsBloc utilsbloc, BuildContext context, String email, String password) async { 
   try{
   utilsbloc.changeSpinnerState(true);
   dynamic objPostValidateCode ={"password": password, "token" :await storage.read(key: 'code'), "correo":email }; 
   String urlApi= ConstantsApp.of(context).appConfig.base_url + ConstantsApp.of(context).urlServices.autentication['changePassword']; 
   final response = await client.post("$urlApi", headers:headers, body:json.encode(objPostValidateCode)).timeout( Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout :(){
      utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false );
   });
     print(json.decode(response.body)); 
     print(response.statusCode); 
   if (response.statusCode == 200) 
    {   
      
      print(json.decode(response.body));
        utilsbloc.changeSpinnerState(false);
        if(json.decode(response.body)['estado']==true )
        {
          Navigator.pushNamed(context, "/login");
        }
        else{
           utilsbloc.openDialog(context, "Ha ocurrido un error", "El código ha expirado o es incorrecto.", null,  true, false );            
        }     
    }
    else{
      utilsbloc.changeSpinnerState(false);
      utilsbloc.openDialog(context, "El correo es invalido", response.body.toString(), null,  true, false );
      return null;
    } 
    } on SocketException catch (_) {
  utilsbloc.openDialog(context, "Error de red", "No tiene conexión a Internet", (){   utilsbloc.changeSpinnerState(false);}, true, false);

    }
   }   
}

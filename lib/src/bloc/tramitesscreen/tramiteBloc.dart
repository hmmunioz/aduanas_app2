import 'dart:async';

import 'package:aduanas_app/src/bloc/bloc.dart';
import 'package:aduanas_app/src/constants/constants.dart';
import 'package:aduanas_app/src/notificationprovider/notification_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:aduanas_app/src/bloc/containerscreens/containerScreensBloc.dart';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:aduanas_app/src/repositories/repository.dart';
import 'package:aduanas_app/src/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TramiteBloc with Validators{

    NotificationProvider notificationProvider =  NotificationProvider.instance;
    UtilsBloc utilsbloc ;
    ContainerScreensBloc containerScreensBloc;
    Repository repository;
    TramiteBloc({this.utilsbloc, this.containerScreensBloc, this.repository});
    List<TramiteModel> _porRecibirTramiteList = [];
    List<TramiteModel> _recibidosTramiteList = [];
    List<TramiteModel> _entregadosTramiteList = [];
     dynamic view_more={
       'porRecibir':false,
       'recibidos':false,
       'entregados':false
     };
 final _tramiteListController = BehaviorSubject<bool>();    
 final _tramitesList = BehaviorSubject<Future<dynamic>>();
 final _tramiteDetailController = BehaviorSubject<TramiteModel>();
 final _isCompleteListLoadingController = BehaviorSubject<bool>();
 final _searchTramiteController = BehaviorSubject<String>();


 Function(bool) get addSinkTramiteList => _tramiteListController.sink.add; ////Set data to block TramiteScreen
 Stream<bool> get  changesTramiteList => _tramiteListController.stream.transform(validateTramiteObj);
Function(TramiteModel) get addSinkTramiteDetail => _tramiteDetailController.sink.add;
Function(bool) get addIsCompleteLoading => _isCompleteListLoadingController.sink.add;
Stream<bool> get  getTransformerIsCompleteLoading => _isCompleteListLoadingController.stream.transform(validateTramiteObj);

Function(String) get addSearchController => _searchTramiteController.sink.add;
  String getSearchTramiteValue(){
   print(_searchTramiteController.value);   
  return _searchTramiteController.value;
}
void changeViewMore(int type){
   switch (type) {
     case 1 :
       view_more['porRecibir']=!view_more['porRecibir'];
       break;
    case 2 :
       view_more['recibidos']=!view_more['recibidos'];
       break;
    case 3 :
       view_more['entregados']=!view_more['entregados'];
       break;
     default:
   }
   addSinkTramiteList(true); 
}

void deleteTramite(BuildContext context, String numeroTramite){
  repository.dbProvider.setInstanceTramite();  
  repository.dbProvider.dbProviderTramite.deleteTramite(numeroTramite);
  containerScreensBloc.changeActualScreen(0);
}

bool getIsCompleteLoadingValue(){
  return _isCompleteListLoadingController.value;
}

 void changeTramiteState(BuildContext context, List listaActual, int position, int tipoTramite){
   var objetoActual = listaActual[position];
   listaActual.removeAt(position);
   tipoTramite==1 ? _recibidosTramiteList.add(objetoActual) : _entregadosTramiteList.add(objetoActual);
   addSinkTramiteList(true);
   refreshTramites(context);
   utilsbloc.changeSpinnerState(false);
   Navigator.of(context).pop();
   containerScreensBloc.changeActualScreen(1);
 }
  TramiteModel getValueTramiteDetail(){
   return _tramiteDetailController.value;
  }

  void changeTramite(BuildContext context, TramiteModel tramiteObj)
  {   
     int porRecibirExist = _porRecibirTramiteList.indexWhere((tramite) => tramite.getId== tramiteObj.getId); 
     int recibidoExist = _recibidosTramiteList.indexWhere((tramite) => tramite.getId== tramiteObj.getId); 
     int entregadoExist = _entregadosTramiteList.indexWhere((tramite) => tramite.getId== tramiteObj.getId);   
     int tipoTramite = (porRecibirExist!= null && porRecibirExist!= -1)? 1 : ((recibidoExist!= null && recibidoExist!= -1)?2: ((entregadoExist!= null && entregadoExist!= -1)?3:-1));
     int posicionTramite = (porRecibirExist!= null && porRecibirExist!= -1)? porRecibirExist : ((recibidoExist!= null && recibidoExist!= -1)?recibidoExist: ((entregadoExist!= null && entregadoExist!= -1)?entregadoExist:-1));
     
    if(tipoTramite!=null && tipoTramite!=-1){
       switch (tipoTramite) {
         case 1 : 
          return changeTramiteState(context, _porRecibirTramiteList, posicionTramite, tipoTramite);
         case 2 :
              notificationProvider.deleteNotification(_recibidosTramiteList[posicionTramite]);
          return changeTramiteState(context, _recibidosTramiteList, posicionTramite, tipoTramite);
      /*    case 3 :         
          return changeTramiteState(context, _entregadosTramiteList, posicionTramite, tipoTramite); */
           break;
         default:
       }

     }
  }
     List<TramiteModel> listaViewLess(List<TramiteModel> tempTramiteList){
       List<TramiteModel> retorno = new List<TramiteModel>();
         retorno.add(tempTramiteList[0]);
   /*      if(tempTramiteList.length>=1){
       
      //   retorno.add(tempTramiteList[1]);
        }
        /* else if(tempTramiteList.length==1){
          retorno.add(tempTramiteList[0]);
        } */ */
        return retorno;
     }  

  getListLength(){
    dynamic listLength={
      '_porRecibirTramiteList':_porRecibirTramiteList,
        '_recibidosTramiteList':_recibidosTramiteList,
          '_entregadosTramiteList':_entregadosTramiteList
    };
    return listLength;
  }
 getViewMore(){  
    return view_more;
  }
 
  List<TramiteModel> getPorRecibirList(){
     return  (getSearchTramiteValue()=="" || getSearchTramiteValue()==null) ?  ( view_more['porRecibir']!=true? _porRecibirTramiteList: listaViewLess(_porRecibirTramiteList)) :_porRecibirTramiteList.where((tr) =>  tr.getNumeroTramite.contains(getSearchTramiteValue())).toList();
    }

  List<TramiteModel> getRecibidosList(){
     return  (getSearchTramiteValue()=="" || getSearchTramiteValue()==null)?   ( view_more['recibidos']!=true? _recibidosTramiteList : listaViewLess(_recibidosTramiteList)):_recibidosTramiteList.where((tr) =>  tr.getNumeroTramite.contains(getSearchTramiteValue())).toList();
   }

  List<TramiteModel> getEntregadosList(){
     return (getSearchTramiteValue()=="" || getSearchTramiteValue()==null)?  ( view_more['recibidos']!=true? _entregadosTramiteList : listaViewLess(_entregadosTramiteList))   : _entregadosTramiteList.where((tr) =>  tr.getNumeroTramite.contains(getSearchTramiteValue())).toList();
   }
  
  void cleanControllers(){
    _porRecibirTramiteList=[];
    _recibidosTramiteList=[];
    _entregadosTramiteList=[];
  }
   refreshAddTramites(tramiteList, BuildContext context)
   {

     List<TramiteModel> _porRecibirTramiteList = tramiteList['porRecibir'];
     List<TramiteModel> _recibidosTramiteList = tramiteList['recibidos'];
     List<TramiteModel> _entregadosTramiteList = tramiteList['entregados']; 
     repository.dbProvider.setInstanceTramite();  
          utilsbloc.changeSpinnerState(false);
    _porRecibirTramiteList.forEach((f) =>  repository.dbProvider.dbProviderTramite.addTramite(TramiteModel.fromDb(f.toJson()))
     .then((idTramite)=>{
        idTramite>0 ? print(f.getActividad) :print("failed tramite ")                   
       })
     );

      _recibidosTramiteList.forEach((f) =>  repository.dbProvider.dbProviderTramite.addTramite(TramiteModel.fromDb(f.toJson()))
     .then((idTramite)=>{
        idTramite>0 ? print(f.getActividad) :print("failed tramite ")                   
       })
     );

      _entregadosTramiteList.forEach((f) =>  repository.dbProvider.dbProviderTramite.addTramite(TramiteModel.fromDb(f.toJson()))
     .then((idTramite)=>{
        idTramite>0 ? print(f.getActividad) :print("failed tramite ")                   
       })
     );
     utilsbloc.changeSpinnerState(false);         
   }

   refreshTramites(BuildContext context,){
      utilsbloc.changeSpinnerState(true);
     repository.apiProvider.tramiteApiProvider.getTramites(context, utilsbloc).then((tramiteList)=>{
     refreshAddTramites(tramiteList, context  )
     }); 
   }

  getTramitesByUser() async { 
    utilsbloc.changeSpinnerState(true);
    repository.dbProvider.setInstanceTramite();  
    repository.dbProvider.dbProviderTramite.getTramites().then((listaTramitesTemp){      
      _porRecibirTramiteList =listaTramitesTemp['porRecibir'];
    _recibidosTramiteList = listaTramitesTemp['recibidos'];
    _entregadosTramiteList = listaTramitesTemp['entregados'];
    addSinkTramiteList(true);
    utilsbloc.changeSpinnerState(false);    
    });
    
  }

  changeTramiteById(BuildContext context, TramiteModel tramiteObj) async {
     utilsbloc.changeSpinnerState(true);   
    repository.tramiteRepository.changeTramite(tramiteObj.getId, tramiteObj.getEstado, utilsbloc, context).then((resultChangeTramiteApi)=> 
      (resultChangeTramiteApi!=false && resultChangeTramiteApi!=null)? repository.dbProvider.dbProviderTramite.updateTramite(tramiteObj).then((resultChangeTramiteDB)=> changeTramite(context, tramiteObj )):print("error")
    ).timeout( Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout : () => utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false ));   
    
  } 

  void searchTramiteByNum(BuildContext context, String tramiteNum, Function controllerReset, Bloc bloc ) async{
  //  controllerReset();
/*     controllerReset(); */
     repository.dbProvider.dbProviderTramite.getTramite(tramiteNum).then((trm) {          
        trm!=null?utilsbloc.settingModalBottomSheet(context, trm,(){ changeTramiteById(context, trm);})
        :utilsbloc.openDialog(context, "Ha ocurrido un error","El tramite que busca no existe.", ()=> bloc.containerScreens.changeActualScreen(1), true, false) ;
       
       } );
}      
        

   dispose(){
      _tramiteListController.close();
      _tramitesList.close();
      _isCompleteListLoadingController.close();
      _tramiteDetailController.close();
      _searchTramiteController.close();
    }
}
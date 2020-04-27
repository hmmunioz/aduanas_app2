import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/repositories/repository.dart';
import 'package:aduanas_app/src/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RecoverEmailBloc with Validators{
    Repository repository;
    UtilsBloc utilsBloc;
    RecoverEmailBloc({this.repository});    

  ///RecoverPassEmailScreen
    final _phoneRecoverController = BehaviorSubject<String>();
     ////Trasnform inData to outData RecoverPassEmailScreen
    Stream<String> get getEmailRecover => _phoneRecoverController.stream.transform(validateEmail);
    ////Get data to block RecoverPassEmailScreen 
    Function(String) get getValueEmailRecover => getDataEmailRecover();
    ////Set data to block RecoverPassEmailScreen
    Function(String) get changeEmailRecover => _phoneRecoverController.sink.add;
     //RecoverPassEmailScreen Methods
    getDataEmailRecover(){
      final valueEmailRecover = _phoneRecoverController.value;       
      return valueEmailRecover;
    }
    sendEmail(BuildContext context){         
        repository.apiProvider.autenticationApiProvider.sendEmail(utilsBloc, context, getDataEmailRecover());/* .then((onValue)=>print(onValue)); *//* .getTramites(context).then((tramiteList)=>{
         addTramitesTolocalData(tramiteList) }).timeout(Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout : () => utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", null, true, false ));                  
  */
    }
    dispose(){
      _phoneRecoverController.close();
    }
}
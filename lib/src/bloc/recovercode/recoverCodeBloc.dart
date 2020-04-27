import 'package:aduanas_app/src/bloc/recoveremail/recoveEmailBloc.dart';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/repositories/repository.dart';
import 'package:aduanas_app/src/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RecoverCodeBloc with Validators{
  Repository repository;
  UtilsBloc utilsBloc ;
  RecoverEmailBloc recoverEmailBloc;
  RecoverCodeBloc({this.repository, this.recoverEmailBloc});
  
    final _codeRecoverController = BehaviorSubject<String>();  ///RecoverPassCodeScreen 
    Stream<String> get getCodeRecover => _codeRecoverController.stream.transform(validateCodeRecover);   ////Trasnform inData to outData RecoverPassCodeScreen
    Function(String) get changeCodeRecover => _codeRecoverController.sink.add;  ////Set data to block RecoverPassCodeScreen
     validateCode(BuildContext context){
      repository.apiProvider.autenticationApiProvider.validateCode(utilsBloc, context, recoverEmailBloc.getDataEmailRecover(), getDataCodeRecover());
    }
    //RecoverPassCodeScreen Methods
    getDataCodeRecover(){
      final valueCodeRecover = _codeRecoverController.value;
      return valueCodeRecover;
    }
    dispose(){
        _codeRecoverController.close();
    }

}
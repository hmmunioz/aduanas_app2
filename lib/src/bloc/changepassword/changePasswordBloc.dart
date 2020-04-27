import 'package:aduanas_app/src/bloc/recoveremail/recoveEmailBloc.dart';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/models/password_model.dart';
import 'package:aduanas_app/src/repositories/repository.dart';
import 'package:aduanas_app/src/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc with Validators{      
    UtilsBloc utilsbloc ;
    Repository repository;
    RecoverEmailBloc recoverEmailBloc;

    ChangePasswordBloc({this.utilsbloc, this.repository, this.recoverEmailBloc});
    final _equalPassController = BehaviorSubject<PasswordModel>();///ChangePasswordScreen
    Stream<bool> get getChangePassword => _equalPassController.stream.transform(validateEqualPassword);     ////Trasnform inData to outData ChangePasswordScreen
    Function(PasswordModel) get changePassword =>  _equalPassController.sink.add; ////Set data to block ChangePassword
    sendNewCredentials(BuildContext context){
          repository.apiProvider.autenticationApiProvider.sendNewCredentials(utilsbloc, context, recoverEmailBloc.getDataEmailRecover(), getValuePasswordModel());
    }
    String getValuePasswordModel(){
      return _equalPassController.value.getNewPassword;
    }
    dispose(){
      _equalPassController.close();
    }
}
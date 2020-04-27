

import 'package:aduanas_app/src/bloc/recovercode/recoverCodeBloc.dart';
import 'package:aduanas_app/src/bloc/recoveremail/recoveEmailBloc.dart';
import 'package:aduanas_app/src/bloc/tramitesscreen/tramiteBloc.dart';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/repositories/repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aduanas_app/src/validators/validators.dart';
import 'package:aduanas_app/src/bloc/login/loginSceenBloc.dart';
import 'changepassword/changePasswordBloc.dart';
import 'containerscreens/containerScreensBloc.dart';
import 'firebaseSmsService/smsServiceBloc.dart';

class Bloc with Validators{
  LoginScreenBloc login = new LoginScreenBloc();
  RecoverEmailBloc recoverEmail = new RecoverEmailBloc();
  RecoverCodeBloc recoverCode = new RecoverCodeBloc();
  UtilsBloc utilsBloc = new UtilsBloc();
  ChangePasswordBloc changePassword = new ChangePasswordBloc();
  ContainerScreensBloc containerScreens = new ContainerScreensBloc(); 
  SmsServiceBloc smsService = new SmsServiceBloc();
  TramiteBloc tramiteScreen = new TramiteBloc(); 
  Repository repository = new Repository();
  FlutterSecureStorage storage = new FlutterSecureStorage();


void initInstanceBlocs(){
    login.utilsbloc = utilsBloc;  
    login.repository= repository;
    login.storage = storage;
    recoverEmail.repository= repository;
    recoverCode.repository=repository;
    recoverEmail.utilsBloc=utilsBloc;
    recoverCode.utilsBloc=utilsBloc;    
    tramiteScreen.utilsbloc = utilsBloc;
    tramiteScreen.containerScreensBloc = containerScreens;
    tramiteScreen.repository= repository;
    recoverCode.recoverEmailBloc= recoverEmail;
    changePassword.recoverEmailBloc= recoverEmail;
    changePassword.repository= repository;
    changePassword.utilsbloc= utilsBloc;
    utilsBloc.tramiteBloc= tramiteScreen;
    utilsBloc.containerScreensBloc= containerScreens;
    login.tramiteBloc= tramiteScreen;
    containerScreens.tramiteBloc= tramiteScreen;
 }
disposeLogin(){
     /*    login.dispose();
      recoverEmail.dispose();
      recoverCode.dispose();
      changePassword.dispose(); */
}
  //Clean memory
  dispose()
  {
      login.dispose();
      recoverEmail.dispose();
      recoverCode.dispose();
      changePassword.dispose();
      containerScreens.dispose();
      tramiteScreen.dispose();
      utilsBloc.dipose();  
      repository.dbProvider.closeDb();
  }
}
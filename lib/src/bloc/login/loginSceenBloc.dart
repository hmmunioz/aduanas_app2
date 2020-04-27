import 'package:aduanas_app/src/bloc/tramitesscreen/tramiteBloc.dart';
import 'package:aduanas_app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/models/profile_model.dart';
import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:aduanas_app/src/repositories/repository.dart';
import 'package:aduanas_app/src/validators/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LoginScreenBloc with Validators {
  UtilsBloc utilsbloc;
  TramiteBloc tramiteBloc;
  Repository repository;
  ProfileModel profileModelRes;
  FlutterSecureStorage storage;

  String token;
  LoginScreenBloc({this.utilsbloc, this.repository, this.profileModelRes, this.storage, this.token});

  ///LoginScreen
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _profileController= BehaviorSubject<ProfileModel>();
  ////Trasnform inData to outData LoginScreen
  Stream<String> get getEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get getPass =>
      _passwordController.stream.transform(validatePass);
  Stream<bool> get submitValid =>
      Rx.combineLatest2(getEmail, getPass, (e, p) => true);
  ////Get data to block LoginScreen
  Function(String) get getValueEmail => getDataEmail();
  Function(String) get getValuePass => getDataPass();

  ////Set data to block LoginScreen
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePass => _passwordController.sink.add;
  Function(ProfileModel) get addSinkProfile => _profileController.sink.add;

  //Logic Bloc Methods
   getTokenLogin() async {        
    token = await storage.read(key: 'jwt');
    return  token;
  }
  
  Future<ProfileModel> addProfileData() async{
      repository.dbProvider.setInstanceProfile();
      profileModelRes = await repository.dbProvider.dbProviderProfile.getProfile(); 
      addSinkProfile(profileModelRes);
      return profileModelRes;
  }  
  
  logOut(BuildContext context) async{
  await  storage.delete(key: 'fechaSincroniza');
   await storage.deleteAll();
   tramiteBloc.cleanControllers();
   repository.dbProvider.deleteDataBase();  
   Navigator.pop(context);
   Navigator.pushReplacementNamed(context, "/splashRcbScreen");
  }


 void singOk(Function addProfileLoginOk, BuildContext context, Function loginAllOk) async {   
        repository.dbProvider.setInstanceProfile();
        repository.dbProvider.dbProviderProfile.getProfile().then((pf)=>{
             addProfileLoginOk(pf, context, loginAllOk)
        });
     }   
    
   void addTramitesTolocalData(tramiteList, Function loginAllOk ) async{
     List<TramiteModel> _porRecibirTramiteList = tramiteList['porRecibir'];
     List<TramiteModel> _recibidosTramiteList = tramiteList['recibidos'];
     List<TramiteModel> _entregadosTramiteList = tramiteList['entregados']; 
     repository.dbProvider.setInstanceTramite();  
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
     loginAllOk();
  }
  void loginResult(resultLogin, BuildContext context, Function loginAllOk) async{      
        repository.dbProvider.setInstanceProfile();  
        repository.dbProvider.dbProviderProfile
                     .addProfile(ProfileModel.fromDb(resultLogin)).then((idProfile)=>{
                      idProfile>0  ? singOk(addProfileLoginOk, context, loginAllOk) : utilsbloc.openDialog(context, "Ha ocurrido un error", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false )
       });        
     }    

  void addProfileLoginOk(ProfileModel pf, BuildContext context, Function loginAllOk){
       profileModelRes =pf;
       addSinkProfile(profileModelRes);          
        repository.apiProvider.tramiteApiProvider.getTramites(context, utilsbloc).then((tramiteList)=>{
         addTramitesTolocalData(tramiteList, loginAllOk) }).timeout(Duration (seconds:ConstantsApp.of(context).appConfig.timeout), onTimeout : () => utilsbloc.openDialog(context, "Ha ocurrido un error.", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false ));                  
   }    

  login(Function loginAllOk, BuildContext context,) async {
   
    utilsbloc.changeSpinnerState(true);
    repository
        .apiProvider.autenticationApiProvider
        .login(getDataEmail(), getDataPass(),  utilsbloc, context,).then((resultLogin){
        if(resultLogin!=null)
             {  repository
              .apiProvider.autenticationApiProvider
              .getPhoneData(utilsbloc, context).then((result){
                 result!=null?loginResult(resultLogin, context, loginAllOk): utilsbloc.openDialog(context, "Ha ocurrido un error", "Intente de nuevo porfavor.", (){utilsbloc.changeSpinnerState(false);}, true, false );
             });        
             }
             else{
               storage.delete(key: 'jwt');
               utilsbloc.openDialog(context, "Ha ocurrido un error.", "Usuario o contraseña invalidos", (){utilsbloc.changeSpinnerState(false);},  true, false );
             }              
        });   
  }
  

  Future<ProfileModel> getProfile() async {    
    repository.dbProvider.setInstanceProfile();
    profileModelRes =  await repository.dbProvider.dbProviderProfile.getProfile();
    addSinkProfile(profileModelRes);
    return profileModelRes;
  }

  getDataEmail() {
    String valueEmail = _emailController.value;
    return valueEmail;
  }

   getDataProfile() {
    ProfileModel valueProfile = _profileController.value;
    return valueProfile;
  }

  getDataPass() {
    String valuePass = _passwordController.value;
    return valuePass;
  }


  dispose() {
    _emailController.close();
    _passwordController.close();
    _profileController.close();
  }
}

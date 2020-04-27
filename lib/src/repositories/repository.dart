import 'package:aduanas_app/src/apiprovider/apiProvider.dart';
import 'package:aduanas_app/src/apiprovider/tramiteApiProvider.dart';
import 'package:aduanas_app/src/dbprovider/db_provider.dart';
import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:aduanas_app/src/repositories/autenticationRepository.dart';
import 'package:aduanas_app/src/repositories/tramiteRepository.dart';


class Repository {
    DBProvider dbProvider; 
  ApiProvider apiProvider =  ApiProvider.get();
  TramiteRepository tramiteRepository = TramiteRepository.get();
  AutenticationRepository autenticationRepository =  AutenticationRepository.get();
  initDb(){
    dbProvider = DBProvider.instance;    
  }
 
  Repository(){
   dbProvider = DBProvider.instance;
   apiProvider =  ApiProvider.get();
  tramiteRepository = TramiteRepository.get();
  autenticationRepository =  AutenticationRepository.get();
  initRepository();
  }
  void initRepository(){
     print("init repo");
      //dbProvider.init();
      tramiteRepository.tramiteApiProvider = apiProvider.tramiteApiProvider;    
      autenticationRepository.autenticationApiProvider= apiProvider.autenticationApiProvider;
      autenticationRepository.dbProvider= dbProvider;
  }


} 
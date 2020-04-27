


import 'package:aduanas_app/src/apiprovider/autenticationApiProvider.dart';
import 'package:aduanas_app/src/dbprovider/db_provider.dart';
import 'package:aduanas_app/src/models/profile_model.dart';

class AutenticationRepository {
  static final AutenticationRepository _autenticationRepository = new AutenticationRepository();
  AutenticationApiProvider autenticationApiProvider;
  DBProvider dbProvider;

  static AutenticationRepository get(){
    return _autenticationRepository
    ;
  }

   


}

import 'package:aduanas_app/src/apiprovider/autenticationApiProvider.dart';
import 'package:aduanas_app/src/apiprovider/tramiteApiProvider.dart';
import 'package:aduanas_app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';

class ApiProvider {
  
     static final ApiProvider _apiProvider = new ApiProvider();

    AutenticationApiProvider autenticationApiProvider = AutenticationApiProvider.get();
    TramiteApiProvider tramiteApiProvider =  TramiteApiProvider.get();
  static ApiProvider get(){  
    return _apiProvider;
  }
}
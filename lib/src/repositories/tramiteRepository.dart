import 'package:aduanas_app/src/apiprovider/tramiteApiProvider.dart';
import 'package:aduanas_app/src/bloc/utils/utilsBloc.dart';
import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:flutter/cupertino.dart';


class TramiteRepository {
   static final TramiteRepository _tramiteRepository = new TramiteRepository();
  
  static TramiteRepository get(){
    return _tramiteRepository;
  }

  TramiteApiProvider tramiteApiProvider;
  Future<dynamic> getTramites(BuildContext context, UtilsBloc utilsbloc) => tramiteApiProvider.getTramites(context, utilsbloc);
  Future<bool> changeTramite(String tramiteId, int estado, UtilsBloc utilsbloc, BuildContext context) => tramiteApiProvider.changeTramite(tramiteId, estado, utilsbloc, context );


}
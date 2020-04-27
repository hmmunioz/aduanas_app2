import 'package:aduanas_app/src/models/tramites_model.dart';
import 'package:sqflite/sqflite.dart';
class DBProviderTramite{
String tableName="tramites";
Future<Database> database;
DBProviderTramite({this.database});

Future<int> addTramite(TramiteModel tramiteModel) async{   
    Database db = await database;
    int idBdd = await db.insert(tableName,
    tramiteModel.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace,    
    );      
    return idBdd;
  } 

  Future<int> deleteTramite(String numeroTramite) async{   
   Database db = await database;
  int idBdd  = await db.delete(tableName, where: 'numeroTramite = ?', whereArgs: [numeroTramite]);

  return idBdd;
  } 
      
  Future<dynamic> getTramites() async{       
    Database db = await database;
     var maps = await db.query(tableName, 
      columns: null
     );
  
     if(maps.length > 0) {
      dynamic responseData = {
        'porRecibir':maps.map<TramiteModel>((tr)=> new TramiteModel.fromDb(tr)).where((tr)=>tr.getEstado==1).toList(),
        'recibidos': maps.map<TramiteModel>((tr)=> new TramiteModel.fromDb(tr)).where((tr)=>tr.getEstado==2).toList(),
        'entregados': maps.map<TramiteModel>((tr)=> new TramiteModel.fromDb(tr)).where((tr)=>tr.getEstado==3).toList(),
      };
      return responseData;
     }     
     return null;
   }

    Future<TramiteModel> getTramite(String tramiteNum) async{  
         print("dataabaaaseeeee");
  
    Database db = await database;
     var maps = await db.query(tableName, 
      columns: null,
      where: 'numeroTramite = ?', whereArgs: [tramiteNum]
     );
  
     if(maps!=null && maps.length>0) {
      return TramiteModel.fromDb(maps[0]);
     }     
     else{
       print("nuuuuuuuuuuull");
              return null;
     }
 //!    return null;
   }

    Future<TramiteModel> updateTramite(TramiteModel tramiteModel) async {
    print("Este es el estado");
    print(tramiteModel.getEstado);
    Database db = await database;
    tramiteModel.getEstado==1?tramiteModel.setEstado(2):tramiteModel.setEstado(3);    
    await db.update(tableName, tramiteModel.toJson(),
        where: 'id = ?', whereArgs: [tramiteModel.getId]);
    return await getTramite(tramiteModel.getId);

  }  
}
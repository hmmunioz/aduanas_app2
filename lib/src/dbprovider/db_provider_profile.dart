import 'package:aduanas_app/src/models/profile_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class DBProviderProfile{
String tableName="profile";
Future<Database> database;
DBProviderProfile({this.database});
final storage = new FlutterSecureStorage();
Future<int> addProfile(ProfileModel profileModel) async{
    Database db = await database;   
    int idBdd = await db.insert(tableName,
    profileModel.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace,    
    );  
    return idBdd;
  } 
      
  Future<ProfileModel> getProfile() async{
    Database db = await database;
     var maps = await db.query(tableName, 
      columns: null
     );

     if(maps.length > 0){
        print(ProfileModel.fromDb(maps[0]).getCorreo);
        return ProfileModel.fromDb(maps[0]);             
     }     
     return null;
   }
}
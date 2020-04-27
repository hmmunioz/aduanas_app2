import 'dart:io';
import 'package:aduanas_app/src/dbprovider/db_provider_profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_provider_tramites.dart';
class DBProvider{
DBProviderProfile dbProviderProfile = new DBProviderProfile();
DBProviderTramite dbProviderTramite = new DBProviderTramite();
static final _dbName = "aduanasDB.db";
static final  List<String> tablas=["profile", "tramites"];
      Database dbtemp;
      // Increment this version when you need to change the schema.
      static final _dbVersion = 1;
      // Make this a singleton class.
      DBProvider._privateConstructor();
      static final DBProvider instance = DBProvider._privateConstructor();
      // Only allow a single open connection to the database.
      static Database _db;
      Future<Database> get database async {
        if (_db != null) return _db;
        _db = await _initDatabase();
        return _db;
      }
        /* ; */
      // open the database
      _initDatabase() async {
        // The path_provider plugin gets the right directory for Android or iOS.
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, _dbName);
        // Open the database. Can also add an onUpdate callback parameter.
        return await openDatabase(path,
            version: _dbVersion,
            onCreate: _onCreate);            
      }

      // SQL string to create the database 
      Future _onCreate(Database db, int version) async {
            await db.execute("""
                  CREATE TABLE profile
                (
                  usuarioUUID TEXT PRIMARY KEY,
                  nombre TEXT,
                  correo TEXT,
                  telefono TEXT
                )                    
                """);       

            await db.execute("""            
                CREATE TABLE tramites
                (
                 actividad TEXT not null,
                 cliente TEXT not null,
                 responsable TEXT not null,
                 estado integer not null,
                 id TEXT PRIMARY KEY not null, 
                 numeroTramite TEXT not null,
                 fechaRegistro TEXT not null,
                 fechaExpiracion Text not null ,
                 tipoTramite Text not null                
                )        
                """);
      }
 void closeDb() async{

        await _db.close();
 }
  // Database helper methods:              
   void deleteDataBase()async{
     Database db = await database;  
     await db.delete("profile");
    await db.delete("tramites");

   }
   void setInstanceProfile() {     
    dbProviderProfile.database=  getDataInstance();   
   }
   void setInstanceTramite(){
     dbProviderTramite.database=  getDataInstance();
   }
   Future<Database> getDataInstance()async{
   return await database;
   }   

}

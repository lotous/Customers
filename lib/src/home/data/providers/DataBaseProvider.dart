
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';



class DatabaseProvider {


  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database _db;  
  
  String customersTable = 'Customers';
  
  Future<Database> get instance async {
    if (_db != null) return _db;
    _db = await init();
    return _db;
  }  
  
  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "CustomerDatbase.db");  

    var database = await openDatabase(path,
        version: 1, 
        onCreate: create, 
        onUpgrade: upgrade
    );
    return database;
  }

  void upgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }
  

  void create(Database database, int version) async {
    await database.execute("CREATE TABLE $customersTable ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "identifierType TEXT NOT NULL, "
        "identifier TEXT NOT NULL, "
        "firstName TEXT NOT NULL, "
        "lastName TEXT NOT NULL, "
        "numberPhone TEXT NOT NULL, "
        "email TEXT NOT NULL, "
        "companyName TEXT NOT NULL "
        ")");
  }


}
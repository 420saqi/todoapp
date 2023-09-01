


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static String dbName= 'notes.db';
  static String tableName= 'NotesTable';

  static Future<Database> getDb()async{
    final dbPath = await getDatabasesPath();
     return openDatabase(join(dbPath,dbName),version: 1,onCreate: (db, version) {
       return db.execute(''' 
       CREATE TABLE $tableName(
       id INTEGER PRIMARY KEY,
       descriptionText TEXT NOT NULL,
       date TEXT NOT NULL,
       priority TEXT NOT NULL    
       )
       ''');
       // DO NOT ADD , AFTER THE LAST COLUMN LIKE ABOVE PRIORITY
     },);
  }

  static Future<int> insertNoteToDb(String des, date, priority) async{
    final db = await getDb();

    return db.insert(tableName, {
      'descriptionText' : des,
      'date' : date,
      'priority' : priority
    });
  }

  static Future<List<Map<String,dynamic>>> fetchData()async{
    final db = await getDb();
    return db.query(tableName);
  }

  static Future<int> deleteFromDb(int id)async{
    final db = await getDb();
    return db.delete(tableName, where: 'id=?', whereArgs: [id]);
  }

}
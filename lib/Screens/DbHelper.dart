import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  // Database? db;
  Future<Database> createDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              """CREATE TABLE Test (id INTEGER PRIMARY KEY, language_1 TEXT, text_controller TEXT,language_2 TEXT,text_translated TEXT,isFav TEXT)""");

          await db.execute(
              """CREATE TABLE TestFav (id INTEGER PRIMARY KEY, language_1 TEXT, text_controller TEXT,language_2 TEXT,text_translated TEXT,isFav TEXT)""");
        });
    // print(pat);
    return database;
  }
}
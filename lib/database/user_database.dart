import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final userTable = 'userTable';
final TokenTable = 'users';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  late Database _database;

  Future<Database> get database async {
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "User.db");

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: initDB,
      onUpgrade: onUpgrade,
    );
    return database;
  }

  void onUpgrade(
    Database database,
    int oldVersion,
    int newVersion,
  ) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $userTable ("
        "id INTEGER PRIMARY KEY, "
        "username TEXT, "
        "token TEXT "
        ")");
  }

  void initDBToken(Database database, int version) async {
    await database.execute("CREATE TABLE $TokenTable ("
        "id INTEGER PRIMARY KEY, "
        "refresh TEXT, "
        "access TEXT "
        ")");
  }
}

class TokenDBProvider {
  static final TokenDBProvider dbProvider = TokenDBProvider();

  late Database _database;

  Future<Database> get database async {
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print("DIRRRRRRRRRR: ${documentsDirectory.path}");
    String path = join(documentsDirectory.path, "User.db");

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: initDBToken,
      onUpgrade: onUpgrade,
    );
    // database.rawQuery("""
    //     CREATE TABLE $TokenTable (
    //       id INTEGER PRIMARY KEY AUTOINCREMENT,
    //       access TEXT,
    //       refresh TEXT
    //     )
    // """);
    print("DDDDDATATATATATATAA ${database}");
    return database;
  }

  void onUpgrade(
    Database database,
    int oldVersion,
    int newVersion,
  ) {
    if (newVersion > oldVersion) {}
  }

  void initDBToken(Database database, int version) async {
    return await database.execute("CREATE TABLE $TokenTable ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "access TEXT,"
        "refresh TEXT"
        ")");
  }
}

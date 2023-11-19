import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:parkez/data/models/user.dart';
import 'package:path/path.dart' as p;

class UserLocalDatabaseImpl {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, "UserDB.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        id TEXT PRIMARY KEY,
        email TEXT,
        name TEXT,
        picture TEXT,
        reservations TEXT
      )
      ''');
  }

  Future<void> saveUser(User user) async {
    final db = await database;
    await db.insert(
      'User',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User> getUser() async {
    final db = await database;
    final maps = await db.query('User');
    return User.fromJson(maps.first);
  }
}

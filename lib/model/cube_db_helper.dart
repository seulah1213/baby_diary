import 'dart:io';

import 'package:baby_diary/model/cube_list.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'Cube';

class CubeDBHelper {
  CubeDBHelper._();

  static final CubeDBHelper _db = CubeDBHelper._();

  factory CubeDBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'CubeDB.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            cubeName TEXT,
            cubeMadeDate TEXT,
            cubeEndDate TEXT,
            cubeCount INTEGER
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  createData(Cube cube) async {
    final db = await database;
    var res = await db.insert(tableName, cube.toJson());
    return res;
  }

  getCube(int id) async {
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Cube.fromJson(res.first) : Null;
  }

  Future<List<Cube>> getAllCubes() async {
    final db = await database;
    var res = await db.query(tableName);
    List<Cube> list =
        res.isNotEmpty ? res.map((c) => Cube.fromJson(c)).toList() : [];

    return list;
  }

  updateCube(Cube cube) async {
    final db = await database;
    var res = db.update(tableName, cube.toJson(),
        where: 'id = ?', whereArgs: [cube.id]);
    return res;
  }

  deleteCube(int id) async {
    final db = await database;
    var res = db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  deleteAllCube() async {
    final db = await database;
    db.delete(tableName);
  }
}

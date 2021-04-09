import 'dart:io';

import 'package:baby_diary/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'Food';

class FoodDBHelper {
  FoodDBHelper._();

  static final FoodDBHelper _db = FoodDBHelper._();

  factory FoodDBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'FoodDB.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            eventName TEXT,
            fromDate TEXT,
            toDate TEXT,
            background INTEGER,
            note TEXT,
            eventCount INTEGER,
            memo TEXT
            )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  createFoodData(Food food) async {
    final db = await database;
    var res = await db.insert(tableName, food.toJson());
    return res;
  }

  getFood(int id) async {
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Food.fromJson(res.first) : Null;
  }

  Future<List<Food>> getAllFoods() async {
    final db = await database;
    var res = await db.query(tableName);
    List<Food> list =
        res.isNotEmpty ? res.map((c) => Food.fromJson(c)).toList() : [];

    return list;
  }

  updateFood(Food food) async {
    final db = await database;
    var res = db.update(tableName, food.toJson(),
        where: 'id = ?', whereArgs: [food.id]);
    return res;
  }

  deleteFood(int id) async {
    final db = await database;
    var res = db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  deleteAllFood() async {
    final db = await database;
    db.delete(tableName);
  }
}

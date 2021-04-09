import 'dart:io';

import 'package:baby_diary/model/profile_list.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'Profile';

class ProfileDBHelper {
  ProfileDBHelper._();

  static final ProfileDBHelper _db = ProfileDBHelper._();

  factory ProfileDBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'ProfileDB.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            babyImage TEXT,
            babyName TEXT,
            babyBirth TEXT
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  createProfileData(Profile profile) async {
    final db = await database;
    var res = await db.insert(tableName, profile.toJson());
    return res;
  }

  getProfile(int id) async {
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Profile.fromJson(res.first) : Null;
  }

  Future<List<Profile>> getAllProfiles() async {
    final db = await database;
    var res = await db.query(tableName);
    List<Profile> list =
        res.isNotEmpty ? res.map((c) => Profile.fromJson(c)).toList() : [];

    return list;
  }

  updateProfile(Profile profile) async {
    final db = await database;
    var res = db.update(tableName, profile.toJson(),
        where: 'id = ?', whereArgs: [profile.id]);
    return res;
  }

  deleteProfile(int id) async {
    final db = await database;
    var res = db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  deleteAllProfile() async {
    final db = await database;
    db.delete(tableName);
  }
}

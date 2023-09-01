import 'dart:async';

import 'package:flutter_todos/backend/db_initialize/income_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'accounts_db.dart';
import 'expenses_db.dart';
import 'users_db.dart';

class IncomeDatabase {
  static const _databaseName = 'expenses_app.db';
  static const _databaseVersion = 3;
  static final IncomeDatabase instance = IncomeDatabase._init();

  static Database? _database;

  IncomeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
      onConfigure: _onConfigure,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    UsersDB.createDB(db, version);
    AccountsDB.createDB(db, version);
    ExpensesDB.createDB(db, version);
    IncomeDB.createDB(db, version);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    ExpensesDB.createDB(db, newVersion);
    IncomeDB.createDB(db, newVersion);
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

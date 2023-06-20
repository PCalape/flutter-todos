import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'accounts_db.dart';
import 'todos_db.dart';
import 'users_db.dart';

class ExpensesDatabase {
  static const _databaseName = 'expenses_app.db';
  static const _databaseVersion = 1;
  static final ExpensesDatabase instance = ExpensesDatabase._init();

  static Database? _database;

  ExpensesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _createDB,
        onConfigure: _onConfigure);
  }

  Future<void> _createDB(Database db, int version) async {
    UsersDB.createDB(db, version);
    AccountsDB.createDB(db, version);
    TodosDB.createDB(db, version);
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

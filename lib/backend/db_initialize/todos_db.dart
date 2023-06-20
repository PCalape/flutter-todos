import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';

class TodosDB {
  TodosDB._();

  static Future createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY NOT NULL';
    const textType = 'TEXT';
    const intType = 'INTEGER';
    const notNull = 'NOT NULL';

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableTodos (
        ${TodoFields.id} $idType,
        ${TodoFields.createdAt} $textType,
        ${TodoFields.updatedAt} $textType,
        ${TodoFields.deletedAt} $textType,
        ${TodoFields.title} $textType $notNull,
        ${TodoFields.description} $textType $notNull,
        ${TodoFields.isCompleted} $intType
      )
    ''');

    await db.execute(
        '''CREATE INDEX IF NOT EXISTS todo_id_index ON $tableTodos(${TodoFields.id})''');
  }
}

import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class UsersDB {
  UsersDB._();

  static Future createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY NOT NULL';
    const textType = 'TEXT';
    const notNull = 'NOT NULL';

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableUsers (
        ${UserFields.id} $idType,
        ${UserFields.createdAt} $textType,
        ${UserFields.updatedAt} $textType,
        ${UserFields.deletedAt} $textType,
        ${UserFields.email} $textType $notNull,
        ${UserFields.name} $textType $notNull,
        ${UserFields.photo} $textType
      )
    ''');

    await db.execute(
        '''CREATE INDEX IF NOT EXISTS user_id_index ON $tableUsers(${UserFields.id}, ${UserFields.email})''');
  }
}

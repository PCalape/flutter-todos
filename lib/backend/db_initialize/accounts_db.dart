import 'package:sqflite/sqflite.dart';

import '../models/account.dart';
import '../models/user.dart';

class AccountsDB {
  AccountsDB._();

  static Future createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY NOT NULL';
    const textType = 'TEXT';
    const notNull = 'NOT NULL';

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableAccounts (
        ${AccountFields.id} $idType,
        ${AccountFields.createdAt} $textType,
        ${AccountFields.updatedAt} $textType,
        ${AccountFields.deletedAt} $textType,
        ${AccountFields.name} $textType $notNull,
        ${AccountFields.ownerId} $textType $notNull,
        FOREIGN KEY(${AccountFields.ownerId}) REFERENCES $tableUsers(${UserFields.id}) 
          ON DELETE NO ACTION ON UPDATE NO ACTION
      )
    ''');

    await db.execute(
        '''CREATE INDEX IF NOT EXISTS account_id_index ON $tableAccounts(${AccountFields.id}, ${AccountFields.name})''');
  }
}

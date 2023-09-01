import 'package:sqflite/sqflite.dart';

import '../models/income.dart';

class IncomeDB {
  IncomeDB._();

  static Future createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY NOT NULL';
    const textType = 'TEXT';
    const realType = 'REAL';
    const notNull = 'NOT NULL';

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableIncome (
        ${IncomeFields.id} $idType,
        ${IncomeFields.createdAt} $textType,
        ${IncomeFields.updatedAt} $textType,
        ${IncomeFields.deletedAt} $textType,
        ${IncomeFields.category} $textType $notNull,
        ${IncomeFields.description} $textType $notNull,
        ${IncomeFields.amount} $realType $notNull
      )
    ''');

    await db.execute(
        '''CREATE INDEX IF NOT EXISTS income_id_index ON $tableIncome(${IncomeFields.id})''');
  }
}

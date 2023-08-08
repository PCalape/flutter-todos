import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';

class ExpensesDB {
  ExpensesDB._();

  static Future createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY NOT NULL';
    const textType = 'TEXT';
    const realType = 'REAL';
    const notNull = 'NOT NULL';

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableExpenses (
        ${ExpenseFields.id} $idType,
        ${ExpenseFields.createdAt} $textType,
        ${ExpenseFields.updatedAt} $textType,
        ${ExpenseFields.deletedAt} $textType,
        ${ExpenseFields.category} $textType $notNull,
        ${ExpenseFields.description} $textType $notNull,
        ${ExpenseFields.amount} $realType $notNull
      )
    ''');

    await db.execute(
        '''CREATE INDEX IF NOT EXISTS expense_id_index ON $tableExpenses(${ExpenseFields.id})''');
  }
}

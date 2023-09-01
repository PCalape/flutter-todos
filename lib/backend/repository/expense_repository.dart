import 'package:flutter_todos/backend/models/expense.dart';
import 'package:rxdart/subjects.dart';

import '../db_initialize/db_initialize.dart';

class ExpenseRepository {
  static final ExpenseRepository repository = ExpenseRepository._init();

  ExpenseRepository._init() {
    fetchExpensesForSeeding().then((expenses) {
      _expenseStreamController.add(expenses);
    });
  }

  final _expenseStreamController =
      BehaviorSubject<List<Expense>>.seeded(const []);

  Stream<List<Expense>> fetchAllExpenses() =>
      _expenseStreamController.asBroadcastStream();

  Future<List<Expense>> fetchExpensesForSeeding() async {
    try {
      final db = await IncomeDatabase.instance.database;
      const orderBy = '${ExpenseFields.updatedAt} DESC';
      final result = await db.query(tableExpenses, orderBy: orderBy);
      return result.map((json) => Expense.fromJson(json)).toList();
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> create(Expense expense) async {
    try {
      final db = await IncomeDatabase.instance.database;
      Map<String, Object?> expenseUpdate = expense.toJsonUpdate();
      Map<String, Object?> expenseCreate = expense.toJsonCreate();
      final expenses = [..._expenseStreamController.value];

      //data saving
      List existingExpense = await db
          .query(tableExpenses, where: 'id = ?', whereArgs: [expense.id]);
      if (existingExpense.isNotEmpty) {
        await db.update(tableExpenses, expenseUpdate,
            where: 'id = ?', whereArgs: [expense.id]);

        //stream update
        final expenseIndex = expenses.indexWhere((t) => t.id == expense.id);
        if (expenseIndex >= 0) {
          expenses[expenseIndex] = Expense.fromJson(expenseUpdate);
        } else {
          expenses.insert(0, Expense.fromJson(expenseUpdate));
        }
        _expenseStreamController.add(expenses);
      } else {
        await db.insert(tableExpenses, expenseCreate);

        //stream update
        expenses.insert(0, Expense.fromJson(expenseCreate));
        _expenseStreamController.add(expenses);
      }
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      final db = await IncomeDatabase.instance.database;
      await db.delete(tableExpenses, where: "id = ?", whereArgs: [id]);

      //stream update
      final expenses = [..._expenseStreamController.value];
      final expenseIndex = expenses.indexWhere((t) => t.id == id);
      expenses.removeAt(expenseIndex);
      _expenseStreamController.add(expenses);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }
}

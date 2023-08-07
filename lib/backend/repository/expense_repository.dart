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
      final db = await ExpensesDatabase.instance.database;
      const orderBy = '${ExpenseFields.createdAt} DESC';
      final result = await db.query(tableExpenses, orderBy: orderBy);
      return result.map((json) => Expense.fromJson(json)).toList();
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> create(Expense todo) async {
    try {
      final db = await ExpensesDatabase.instance.database;

      //data saving
      List existingExpense =
          await db.query(tableExpenses, where: 'id = ?', whereArgs: [todo.id]);
      if (existingExpense.isNotEmpty) {
        await db.update(tableExpenses, todo.toJsonUpdate(),
            where: 'id = ?', whereArgs: [todo.id]);
      } else {
        await db.insert(tableExpenses, todo.toJsonCreate());
      }

      //stream update
      final expenses = [..._expenseStreamController.value];
      final expenseIndex = expenses.indexWhere((t) => t.id == todo.id);
      if (expenseIndex >= 0) {
        expenses[expenseIndex] = todo;
      } else {
        expenses.insert(0, todo);
      }
      _expenseStreamController.add(expenses);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      final db = await ExpensesDatabase.instance.database;
      await db.delete(tableExpenses, where: "id = ?", whereArgs: [id]);

      //stream update
      final expenses = [..._expenseStreamController.value];
      final todoIndex = expenses.indexWhere((t) => t.id == id);
      expenses.removeAt(todoIndex);
      _expenseStreamController.add(expenses);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }
}

import 'package:flutter_todos/backend/models/expense.dart';

enum ExpenseViewFilter { all, activeOnly, completedOnly }

extension ExpenseViewFilterX on ExpenseViewFilter {
  bool apply(Expense expense) {
    return true;
  }

  Iterable<Expense> applyAll(Iterable<Expense> expenses) {
    return expenses.where(apply);
  }
}

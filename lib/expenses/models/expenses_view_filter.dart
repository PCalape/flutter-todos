import '../../backend/models/todo.dart';

enum ExpenseViewFilter { all, activeOnly, completedOnly }

extension ExpenseViewFilterX on ExpenseViewFilter {
  bool apply(Todo todo) {
    switch (this) {
      case ExpenseViewFilter.all:
        return true;
      case ExpenseViewFilter.activeOnly:
        return !todo.isCompleted;
      case ExpenseViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  Iterable<Todo> applyAll(Iterable<Todo> todos) {
    return todos.where(apply);
  }
}

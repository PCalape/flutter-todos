part of 'expenses_bloc.dart';

enum ExpenseStatus { initial, loading, success, failure }

final class ExpenseState extends Equatable {
  const ExpenseState({
    this.status = ExpenseStatus.initial,
    this.todos = const [],
    this.filter = ExpenseViewFilter.all,
    this.lastDeletedTodo,
  });

  final ExpenseStatus status;
  final List<Todo> todos;
  final ExpenseViewFilter filter;
  final Todo? lastDeletedTodo;

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  ExpenseState copyWith({
    ExpenseStatus Function()? status,
    List<Todo> Function()? todos,
    ExpenseViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) {
    return ExpenseState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        lastDeletedTodo,
      ];
}

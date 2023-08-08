part of 'expenses_bloc.dart';

enum ExpenseStatus { initial, loading, success, failure }

final class ExpenseState extends Equatable {
  const ExpenseState({
    this.status = ExpenseStatus.initial,
    this.expenses = const [],
    this.filter = ExpenseViewFilter.all,
    this.lastDeletedExpense,
  });

  final ExpenseStatus status;
  final List<Expense> expenses;
  final ExpenseViewFilter filter;
  final Expense? lastDeletedExpense;

  Iterable<Expense> get filteredExpenses => filter.applyAll(expenses);

  ExpenseState copyWith({
    ExpenseStatus Function()? status,
    List<Expense> Function()? expenses,
    ExpenseViewFilter Function()? filter,
    Expense? Function()? lastDeletedExpense,
  }) {
    return ExpenseState(
      status: status != null ? status() : this.status,
      expenses: expenses != null ? expenses() : this.expenses,
      filter: filter != null ? filter() : this.filter,
      lastDeletedExpense: lastDeletedExpense != null
          ? lastDeletedExpense()
          : this.lastDeletedExpense,
    );
  }

  @override
  List<Object?> get props => [
        status,
        expenses,
        filter,
        lastDeletedExpense,
      ];
}

part of 'edit_expense_bloc.dart';

enum EditExpenseStatus { initial, loading, success, failure }

extension EditExpenseStatusX on EditExpenseStatus {
  bool get isLoadingOrSuccess => [
        EditExpenseStatus.loading,
        EditExpenseStatus.success,
      ].contains(this);
}

final class EditExpenseState extends Equatable {
  const EditExpenseState({
    this.status = EditExpenseStatus.initial,
    this.initialExpense,
    this.description = '',
    this.category = '',
    this.amount = 0.0,
    this.expenseDate,
  });

  final EditExpenseStatus status;
  final Expense? initialExpense;
  final String description;
  final String category;
  final double amount;
  final DateTime? expenseDate;

  bool get isNewExpense => initialExpense == null;

  EditExpenseState copyWith({
    EditExpenseStatus? status,
    Expense? initialExpense,
    String? description,
    String? category,
    double? amount,
    DateTime? expenseDate,
  }) {
    return EditExpenseState(
      status: status ?? this.status,
      initialExpense: initialExpense ?? this.initialExpense,
      description: description ?? this.description,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      expenseDate: expenseDate ?? this.expenseDate,
    );
  }

  @override
  List<Object?> get props =>
      [status, initialExpense, description, category, amount, expenseDate];
}

part of 'expenses_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

final class ExpenseSubscriptionRequested extends ExpenseEvent {
  const ExpenseSubscriptionRequested();
}

final class ExpenseDeleted extends ExpenseEvent {
  const ExpenseDeleted(this.expense);

  final Expense expense;

  @override
  List<Object> get props => [expense];
}

final class ExpenseUndoDeletionRequested extends ExpenseEvent {
  const ExpenseUndoDeletionRequested();
}

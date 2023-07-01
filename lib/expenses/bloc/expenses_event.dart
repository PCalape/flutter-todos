part of 'expenses_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

final class ExpenseSubscriptionRequested extends ExpenseEvent {
  const ExpenseSubscriptionRequested();
}

final class ExpenseCompletionToggled extends ExpenseEvent {
  const ExpenseCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final Todo todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}

final class ExpenseDeleted extends ExpenseEvent {
  const ExpenseDeleted(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

final class ExpenseUndoDeletionRequested extends ExpenseEvent {
  const ExpenseUndoDeletionRequested();
}

class ExpenseFilterChanged extends ExpenseEvent {
  const ExpenseFilterChanged(this.filter);

  final ExpenseViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class ExpenseToggleAllRequested extends ExpenseEvent {
  const ExpenseToggleAllRequested();
}

class ExpenseClearCompletedRequested extends ExpenseEvent {
  const ExpenseClearCompletedRequested();
}

part of 'edit_expense_bloc.dart';

sealed class EditExpenseEvent extends Equatable {
  const EditExpenseEvent();

  @override
  List<Object> get props => [];
}

final class EditExpenseDescriptionChanged extends EditExpenseEvent {
  const EditExpenseDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

final class EditExpenseCategoryChanged extends EditExpenseEvent {
  const EditExpenseCategoryChanged(this.category);

  final String category;

  @override
  List<Object> get props => [category];
}

final class EditExpenseAmountChanged extends EditExpenseEvent {
  const EditExpenseAmountChanged(this.amount);

  final double amount;

  @override
  List<Object> get props => [amount];
}

final class EditExpenseSubmitted extends EditExpenseEvent {
  const EditExpenseSubmitted();
}

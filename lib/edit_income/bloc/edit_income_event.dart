part of 'edit_income_bloc.dart';

sealed class EditIncomeEvent extends Equatable {
  const EditIncomeEvent();

  @override
  List<Object> get props => [];
}

final class EditIncomeDescriptionChanged extends EditIncomeEvent {
  const EditIncomeDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

final class EditIncomeCategoryChanged extends EditIncomeEvent {
  const EditIncomeCategoryChanged(this.category);

  final String category;

  @override
  List<Object> get props => [category];
}

final class EditIncomeAmountChanged extends EditIncomeEvent {
  const EditIncomeAmountChanged(this.amount);

  final double amount;

  @override
  List<Object> get props => [amount];
}

final class EditIncomeSubmitted extends EditIncomeEvent {
  const EditIncomeSubmitted();
}

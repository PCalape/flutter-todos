part of 'edit_income_bloc.dart';

enum EditIncomeStatus { initial, loading, success, failure }

extension EditIncomeStatusX on EditIncomeStatus {
  bool get isLoadingOrSuccess => [
        EditIncomeStatus.loading,
        EditIncomeStatus.success,
      ].contains(this);
}

final class EditIncomeState extends Equatable {
  const EditIncomeState({
    this.status = EditIncomeStatus.initial,
    this.initialIncome,
    this.description = '',
    this.category = '',
    this.amount = 0.0,
  });

  final EditIncomeStatus status;
  final Income? initialIncome;
  final String description;
  final String category;
  final double amount;

  bool get isNewIncome => initialIncome == null;

  EditIncomeState copyWith({
    EditIncomeStatus? status,
    Income? initialIncome,
    String? description,
    String? category,
    double? amount,
  }) {
    return EditIncomeState(
      status: status ?? this.status,
      initialIncome: initialIncome ?? this.initialIncome,
      description: description ?? this.description,
      category: category ?? this.category,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props =>
      [status, initialIncome, description, category, amount];
}

part of 'income_bloc.dart';

enum IncomeStatus { initial, loading, success, failure }

final class IncomeState extends Equatable {
  const IncomeState({
    this.status = IncomeStatus.initial,
    this.income = const [],
    this.filter = IncomeViewFilter.all,
    this.lastDeletedIncome,
  });

  final IncomeStatus status;
  final List<Income> income;
  final IncomeViewFilter filter;
  final Income? lastDeletedIncome;

  Iterable<Income> get filteredIncome => filter.applyAll(income);

  IncomeState copyWith({
    IncomeStatus Function()? status,
    List<Income> Function()? income,
    IncomeViewFilter Function()? filter,
    Income? Function()? lastDeletedIncome,
  }) {
    return IncomeState(
      status: status != null ? status() : this.status,
      income: income != null ? income() : this.income,
      filter: filter != null ? filter() : this.filter,
      lastDeletedIncome: lastDeletedIncome != null
          ? lastDeletedIncome()
          : this.lastDeletedIncome,
    );
  }

  @override
  List<Object?> get props => [
        status,
        income,
        filter,
        lastDeletedIncome,
      ];
}

part of 'income_bloc.dart';

sealed class IncomeEvent extends Equatable {
  const IncomeEvent();

  @override
  List<Object> get props => [];
}

final class IncomeSubscriptionRequested extends IncomeEvent {
  const IncomeSubscriptionRequested();
}

final class IncomeDeleted extends IncomeEvent {
  const IncomeDeleted(this.income);

  final Income income;

  @override
  List<Object> get props => [income];
}

final class IncomeUndoDeletionRequested extends IncomeEvent {
  const IncomeUndoDeletionRequested();
}

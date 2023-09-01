import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/backend/models/income.dart';
import 'package:flutter_todos/backend/repository/income_repository.dart';
import 'package:flutter_todos/income/models/models.dart';

part 'income_event.dart';
part 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  IncomeBloc({
    required IncomeRepository incomeRepository,
  })  : _incomeRepository = incomeRepository,
        super(const IncomeState()) {
    on<IncomeSubscriptionRequested>(_onSubscriptionRequested);
    on<IncomeDeleted>(_onIncomeDeleted);
    on<IncomeUndoDeletionRequested>(_onUndoDeletionRequested);
  }

  final IncomeRepository _incomeRepository;

  Future<void> _onSubscriptionRequested(
    IncomeSubscriptionRequested event,
    Emitter<IncomeState> emit,
  ) async {
    emit(state.copyWith(status: () => IncomeStatus.loading));

    await emit.forEach<List<Income>>(
      _incomeRepository.fetchAllIncome(),
      onData: (income) => state.copyWith(
        status: () => IncomeStatus.success,
        income: () => income,
      ),
      onError: (_, __) => state.copyWith(
        status: () => IncomeStatus.failure,
      ),
    );
  }

  Future<void> _onIncomeDeleted(
    IncomeDeleted event,
    Emitter<IncomeState> emit,
  ) async {
    emit(state.copyWith(lastDeletedIncome: () => event.income));
    await _incomeRepository.delete(event.income.id!);
  }

  Future<void> _onUndoDeletionRequested(
    IncomeUndoDeletionRequested event,
    Emitter<IncomeState> emit,
  ) async {
    assert(
      state.lastDeletedIncome != null,
      'Last deleted income can not be null.',
    );

    final income = state.lastDeletedIncome!;
    emit(state.copyWith(lastDeletedIncome: () => null));
    await _incomeRepository.create(income);
  }
}

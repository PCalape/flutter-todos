import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/backend/models/expense.dart';
import 'package:flutter_todos/backend/repository/expense_repository.dart';

import '../models/expenses_view_filter.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc({
    required ExpenseRepository expenseRepository,
  })  : _expenseRepository = expenseRepository,
        super(const ExpenseState()) {
    on<ExpenseSubscriptionRequested>(_onSubscriptionRequested);
    on<ExpenseDeleted>(_onExpenseDeleted);
    on<ExpenseUndoDeletionRequested>(_onUndoDeletionRequested);
  }

  final ExpenseRepository _expenseRepository;

  Future<void> _onSubscriptionRequested(
    ExpenseSubscriptionRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: () => ExpenseStatus.loading));

    await emit.forEach<List<Expense>>(
      _expenseRepository.fetchAllExpenses(),
      onData: (expenses) => state.copyWith(
        status: () => ExpenseStatus.success,
        expenses: () => expenses,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ExpenseStatus.failure,
      ),
    );
  }

  Future<void> _onExpenseDeleted(
    ExpenseDeleted event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(lastDeletedExpense: () => event.expense));
    await _expenseRepository.delete(event.expense.id!);
  }

  Future<void> _onUndoDeletionRequested(
    ExpenseUndoDeletionRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    assert(
      state.lastDeletedExpense != null,
      'Last deleted expense can not be null.',
    );

    final expense = state.lastDeletedExpense!;
    emit(state.copyWith(lastDeletedExpense: () => null));
    await _expenseRepository.create(expense);
  }
}

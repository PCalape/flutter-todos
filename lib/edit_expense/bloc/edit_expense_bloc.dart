import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/backend/models/expense.dart';
import 'package:flutter_todos/backend/repository/expense_repository.dart';

part 'edit_expense_event.dart';
part 'edit_expense_state.dart';

class EditExpenseBloc extends Bloc<EditExpenseEvent, EditExpenseState> {
  EditExpenseBloc({
    required ExpenseRepository expenseRepository,
    required Expense? initialExpense,
  })  : _expenseRepository = expenseRepository,
        super(
          EditExpenseState(
            initialExpense: initialExpense,
            description: initialExpense?.description ?? '',
            category: initialExpense?.category ?? '',
          ),
        ) {
    on<EditExpenseDescriptionChanged>(_onDescriptionChanged);
    on<EditExpenseCategoryChanged>(_onCategoryChanged);
    on<EditExpenseAmountChanged>(_onAmountChanged);
    on<EditExpenseSubmitted>(_onSubmitted);
  }

  final ExpenseRepository _expenseRepository;

  void _onDescriptionChanged(
    EditExpenseDescriptionChanged event,
    Emitter<EditExpenseState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onCategoryChanged(
    EditExpenseCategoryChanged event,
    Emitter<EditExpenseState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  void _onAmountChanged(
    EditExpenseAmountChanged event,
    Emitter<EditExpenseState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _onSubmitted(
    EditExpenseSubmitted event,
    Emitter<EditExpenseState> emit,
  ) async {
    emit(state.copyWith(status: EditExpenseStatus.loading));
    final expense = (state.initialExpense != null
        ? Expense.fromJson({
            'id': state.initialExpense?.id,
            'description': state.description,
            'category': state.category,
            'amount': state.amount,
          })
        : Expense.fromJson({
            'description': state.description,
            'category': state.category,
            'amount': state.amount,
          }));

    try {
      await _expenseRepository.create(expense);
      emit(state.copyWith(status: EditExpenseStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditExpenseStatus.failure));
    }
  }
}

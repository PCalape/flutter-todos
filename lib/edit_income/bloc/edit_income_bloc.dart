import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/backend/models/income.dart';
import 'package:flutter_todos/backend/repository/income_repository.dart';

part 'edit_income_event.dart';
part 'edit_income_state.dart';

class EditIncomeBloc extends Bloc<EditIncomeEvent, EditIncomeState> {
  EditIncomeBloc({
    required IncomeRepository incomeRepository,
    required Income? initialIncome,
  })  : _incomeRepository = incomeRepository,
        super(
          EditIncomeState(
            initialIncome: initialIncome,
            description: initialIncome?.description ?? '',
            category: initialIncome?.category ?? '',
            amount: initialIncome?.amount ?? 0,
          ),
        ) {
    on<EditIncomeDescriptionChanged>(_onDescriptionChanged);
    on<EditIncomeCategoryChanged>(_onCategoryChanged);
    on<EditIncomeAmountChanged>(_onAmountChanged);
    on<EditIncomeSubmitted>(_onSubmitted);
  }

  final IncomeRepository _incomeRepository;

  void _onDescriptionChanged(
    EditIncomeDescriptionChanged event,
    Emitter<EditIncomeState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onCategoryChanged(
    EditIncomeCategoryChanged event,
    Emitter<EditIncomeState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  void _onAmountChanged(
    EditIncomeAmountChanged event,
    Emitter<EditIncomeState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _onSubmitted(
    EditIncomeSubmitted event,
    Emitter<EditIncomeState> emit,
  ) async {
    emit(state.copyWith(status: EditIncomeStatus.loading));
    final income = (state.initialIncome != null
        ? Income.fromJson({
            'id': state.initialIncome?.id,
            'description': state.description,
            'category': state.category,
            'amount': state.amount,
          })
        : Income.fromJson({
            'description': state.description,
            'category': state.category,
            'amount': state.amount,
          }));

    try {
      await _incomeRepository.create(income);
      emit(state.copyWith(status: EditIncomeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditIncomeStatus.failure));
    }
  }
}

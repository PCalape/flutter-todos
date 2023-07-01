import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/backend/repository/todo_repository.dart';

import '../../backend/models/todo.dart';
import '../models/expenses_view_filter.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc({
    required TodoRepository todoRepository,
  })  : _todoRepository = todoRepository,
        super(const ExpenseState()) {
    on<ExpenseSubscriptionRequested>(_onSubscriptionRequested);
    on<ExpenseCompletionToggled>(_onTodoCompletionToggled);
    on<ExpenseDeleted>(_onTodoDeleted);
    on<ExpenseUndoDeletionRequested>(_onUndoDeletionRequested);
    on<ExpenseFilterChanged>(_onFilterChanged);
    on<ExpenseToggleAllRequested>(_onToggleAllRequested);
    on<ExpenseClearCompletedRequested>(_onClearCompletedRequested);
  }

  final TodoRepository _todoRepository;

  Future<void> _onSubscriptionRequested(
    ExpenseSubscriptionRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: () => ExpenseStatus.loading));

    await emit.forEach<List<Todo>>(
      _todoRepository.fetchAllTodos(),
      onData: (todos) => state.copyWith(
        status: () => ExpenseStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ExpenseStatus.failure,
      ),
    );
  }

  Future<void> _onTodoCompletionToggled(
    ExpenseCompletionToggled event,
    Emitter<ExpenseState> emit,
  ) async {
    await _todoRepository.create(Todo.fromJson({
      ...event.todo.toJsonUpdate(),
      'isCompleted': event.todo.isCompleted ? 0 : 1,
    }));
  }

  Future<void> _onTodoDeleted(
    ExpenseDeleted event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(lastDeletedTodo: () => event.todo));
    await _todoRepository.delete(event.todo.id!);
  }

  Future<void> _onUndoDeletionRequested(
    ExpenseUndoDeletionRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    final todo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: () => null));
    await _todoRepository.create(todo);
  }

  void _onFilterChanged(
    ExpenseFilterChanged event,
    Emitter<ExpenseState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
    ExpenseToggleAllRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    await _todoRepository.toggleCompletion(areAllCompleted);
  }

  Future<void> _onClearCompletedRequested(
    ExpenseClearCompletedRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    await _todoRepository.clearCompleted();
  }
}

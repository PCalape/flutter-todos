import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_todos/app/app.dart';
import 'package:flutter_todos/app/app_bloc_observer.dart';

import 'backend/repository/expense_repository.dart';
import 'backend/repository/todo_repository.dart';

void bootstrap() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final todoRepository = TodoRepository.repository;
  final expenseRepository = ExpenseRepository.repository;

  runZonedGuarded(
    () => runApp(App(
      todoRepository: todoRepository,
      expenseRepository: expenseRepository,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

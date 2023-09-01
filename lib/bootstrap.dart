import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_todos/app/app.dart';
import 'package:flutter_todos/app/app_bloc_observer.dart';

import 'backend/repository/expense_repository.dart';
import 'backend/repository/income_repository.dart';

void bootstrap() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final expenseRepository = ExpenseRepository.repository;
  final incomeRepository = IncomeRepository.repository;

  runZonedGuarded(
    () => runApp(App(
      expenseRepository: expenseRepository,
      incomeRepository: incomeRepository,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

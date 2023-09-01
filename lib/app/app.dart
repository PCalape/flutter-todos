import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/backend/repository/expense_repository.dart';
import 'package:flutter_todos/home/home.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/theme/theme.dart';

import '../backend/repository/income_repository.dart';

class App extends StatelessWidget {
  const App(
      {required this.expenseRepository,
      required this.incomeRepository,
      super.key});

  final ExpenseRepository expenseRepository;
  final IncomeRepository incomeRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider.value(value: expenseRepository),
      RepositoryProvider.value(value: incomeRepository),
    ], child: const AppView());
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ExpensesTheme.light,
      darkTheme: ExpensesTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}

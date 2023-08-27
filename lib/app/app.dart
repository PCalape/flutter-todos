import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/backend/repository/expense_repository.dart';
import 'package:flutter_todos/home/home.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/theme/theme.dart';

class App extends StatelessWidget {
  const App({required this.expenseRepository, super.key});

  final ExpenseRepository expenseRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider.value(value: expenseRepository),
    ], child: const AppView());
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterTodosTheme.light,
      darkTheme: FlutterTodosTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}

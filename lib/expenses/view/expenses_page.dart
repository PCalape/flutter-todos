import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/backend/repository/expense_repository.dart';
import 'package:flutter_todos/edit_expense/edit_expense.dart';
import 'package:flutter_todos/expenses/widgets/widgets.dart';
import 'package:flutter_todos/l10n/l10n.dart';

import '../bloc/expenses_bloc.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseBloc(
        expenseRepository: context.read<ExpenseRepository>(),
      )..add(const ExpenseSubscriptionRequested()),
      child: const ExpenseView(),
    );
  }
}

class ExpenseView extends StatelessWidget {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.expensesOverviewAppBarTitle),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ExpenseBloc, ExpenseState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ExpenseStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.expensesOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<ExpenseBloc, ExpenseState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedExpense != current.lastDeletedExpense &&
                current.lastDeletedExpense != null,
            listener: (context, state) {
              final deletedExpense = state.lastDeletedExpense!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.expensesOverviewExpenseDeletedSnackbarText(
                        deletedExpense.description,
                      ),
                    ),
                    action: SnackBarAction(
                      label: l10n.expensesOverviewUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<ExpenseBloc>()
                            .add(const ExpenseUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state.expenses.isEmpty) {
              if (state.status == ExpenseStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != ExpenseStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    l10n.expensesOverviewEmptyText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final expense in state.filteredExpenses)
                    ExpenseListTile(
                      expense: expense,
                      onDismissed: (_) {
                        context
                            .read<ExpenseBloc>()
                            .add(ExpenseDeleted(expense));
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          EditExpensePage.route(initialExpense: expense),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

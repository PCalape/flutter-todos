import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/backend/repository/income_repository.dart';
import 'package:flutter_todos/edit_income/view/edit_income_page.dart';
import 'package:flutter_todos/income/income.dart';
import 'package:flutter_todos/l10n/l10n.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncomeBloc(
        incomeRepository: context.read<IncomeRepository>(),
      )..add(const IncomeSubscriptionRequested()),
      child: const IncomeView(),
    );
  }
}

class IncomeView extends StatelessWidget {
  const IncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.incomeOverviewAppBarTitle),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<IncomeBloc, IncomeState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == IncomeStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.incomeOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<IncomeBloc, IncomeState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedIncome != current.lastDeletedIncome &&
                current.lastDeletedIncome != null,
            listener: (context, state) {
              final deletedIncome = state.lastDeletedIncome!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.incomeOverviewIncomeDeletedSnackbarText(
                        deletedIncome.description,
                      ),
                    ),
                    action: SnackBarAction(
                      label: l10n.incomeOverviewUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<IncomeBloc>()
                            .add(const IncomeUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<IncomeBloc, IncomeState>(
          builder: (context, state) {
            if (state.income.isEmpty) {
              if (state.status == IncomeStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != IncomeStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    l10n.incomeOverviewEmptyText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final income in state.filteredIncome)
                    IncomeListTile(
                      income: income,
                      onDismissed: (_) {
                        context.read<IncomeBloc>().add(IncomeDeleted(income));
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          EditIncomePage.route(initialIncome: income),
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

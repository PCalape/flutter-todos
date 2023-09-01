import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/backend/models/income.dart';
import 'package:flutter_todos/l10n/l10n.dart';

import '../../backend/repository/income_repository.dart';
import '../bloc/edit_income_bloc.dart';

class EditIncomePage extends StatelessWidget {
  const EditIncomePage({super.key});

  static Route<void> route({Income? initialIncome}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditIncomeBloc(
          incomeRepository: context.read<IncomeRepository>(),
          initialIncome: initialIncome,
        ),
        child: const EditIncomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditIncomeBloc, EditIncomeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditIncomeStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditIncomeView(),
    );
  }
}

class EditIncomeView extends StatelessWidget {
  const EditIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditIncomeBloc bloc) => bloc.state.status);
    final isNewIncome = context.select(
      (EditIncomeBloc bloc) => bloc.state.isNewIncome,
    );
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewIncome
              ? l10n.editIncomeAddAppBarTitle
              : l10n.editIncomeEditAppBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editIncomeSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () =>
                context.read<EditIncomeBloc>().add(const EditIncomeSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [_DescriptionField(), _CategoryField(), _AmountField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditIncomeBloc>().state;
    final hintText = state.initialIncome?.description ?? '';

    return TextFormField(
      key: const Key('editIncomeView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editIncomeDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditIncomeBloc>().add(EditIncomeDescriptionChanged(value));
      },
    );
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditIncomeBloc>().state;
    final hintText = state.initialIncome?.category ?? '';

    return TextFormField(
      key: const Key('editIncomeView_category_textFormField'),
      initialValue: state.category,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editIncomeCategoryLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditIncomeBloc>().add(EditIncomeCategoryChanged(value));
      },
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditIncomeBloc>().state;
    final hintText = state.initialIncome?.amount ?? 0;

    return TextFormField(
      key: const Key('editIncomeView_amount_textFormField'),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      initialValue: state.amount.toString(),
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editIncomeAmountLabel,
        hintText: hintText.toString(),
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context
            .read<EditIncomeBloc>()
            .add(EditIncomeAmountChanged(double.parse(value)));
      },
    );
  }
}

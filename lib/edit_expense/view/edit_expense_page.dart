import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/backend/models/expense.dart';
import 'package:flutter_todos/backend/repository/expense_repository.dart';
import 'package:flutter_todos/edit_expense/edit_expense.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:intl/intl.dart';

class EditExpensePage extends StatelessWidget {
  const EditExpensePage({super.key});

  static Route<void> route({Expense? initialExpense}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditExpenseBloc(
          expenseRepository: context.read<ExpenseRepository>(),
          initialExpense: initialExpense,
        ),
        child: const EditExpensePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditExpenseBloc, EditExpenseState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditExpenseStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditExpenseView(),
    );
  }
}

class EditExpenseView extends StatelessWidget {
  const EditExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditExpenseBloc bloc) => bloc.state.status);
    final isNewExpense = context.select(
      (EditExpenseBloc bloc) => bloc.state.isNewExpense,
    );
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewExpense
              ? l10n.editExpenseAddAppBarTitle
              : l10n.editExpenseEditAppBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editExpenseSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context
                .read<EditExpenseBloc>()
                .add(const EditExpenseSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ExpenseDateField(),
                _DescriptionField(),
                _CategoryField(),
                _AmountField()
              ],
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

    final state = context.watch<EditExpenseBloc>().state;
    final hintText = state.initialExpense?.description ?? '';

    return TextFormField(
      key: const Key('editExpenseView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editExpenseDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      minLines: 2,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context
            .read<EditExpenseBloc>()
            .add(EditExpenseDescriptionChanged(value));
      },
    );
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditExpenseBloc>().state;
    final hintText = state.initialExpense?.category ?? '';

    return TextFormField(
      key: const Key('editExpenseView_category_textFormField'),
      initialValue: state.category,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editExpenseCategoryLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      minLines: 2,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditExpenseBloc>().add(EditExpenseCategoryChanged(value));
      },
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditExpenseBloc>().state;
    final hintText = state.initialExpense?.amount ?? 0;

    return TextFormField(
      key: const Key('editExpenseView_amount_textFormField'),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      initialValue: state.amount == 0 ? null : state.amount.toString(),
      autofillHints: ['0.0'],
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editExpenseAmountLabel,
        hintText: hintText.toString(),
      ),
      maxLength: 300,
      minLines: 2,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context
            .read<EditExpenseBloc>()
            .add(EditExpenseAmountChanged(double.parse(value)));
      },
    );
  }
}

class ExpenseDateField extends StatefulWidget {
  @override
  _ExpenseDateField createState() => _ExpenseDateField();
}

class _ExpenseDateField extends State<ExpenseDateField> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditExpenseBloc>().state;
    _textEditingController.text =
        DateFormat('yyyy-MM-dd').format(state.expenseDate!);

    return TextFormField(
      controller: _textEditingController,
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: l10n.expenseDateTitleLabel //label text of field
          ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: state.expenseDate!,
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            _textEditingController.text = formattedDate;
          });
          context
              .read<EditExpenseBloc>()
              .add(EditExpenseDateChanged(pickedDate));
        }
      },
      readOnly: true,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_expense/edit_expense.dart';
import 'package:flutter_todos/edit_income/view/edit_income_page.dart';
import 'package:flutter_todos/expenses/view/view.dart';
import 'package:flutter_todos/home/home.dart';
import 'package:flutter_todos/income/income.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    // Define a function to handle the FloatingActionButton onPressed callback
    void handleFloatingActionButtonPressed() {
      switch (selectedTab) {
        case HomeTab.expenses:
          Navigator.of(context).push(EditExpensePage.route());
          break;
        case HomeTab.income:
          Navigator.of(context).push(EditIncomePage.route());
          break;
        default:
          Navigator.of(context).push(EditExpensePage.route());
          break;
      }
    }

    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: const [ExpensePage(), IncomePage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        key: const Key('homeView_addExpense_floatingActionButton'),
        onPressed: handleFloatingActionButtonPressed,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.expenses,
              icon: const Icon(Icons.attach_money),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.income,
              icon: const Icon(Icons.arrow_circle_down_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}

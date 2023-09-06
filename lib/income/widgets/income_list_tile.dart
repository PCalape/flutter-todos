import 'package:flutter/material.dart';
import 'package:flutter_todos/backend/models/income.dart';

class IncomeListTile extends StatelessWidget {
  const IncomeListTile({
    required this.income,
    super.key,
    this.onDismissed,
    this.onTap,
  });

  final Income income;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key('incomeListTile_dismissible_${income.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(border: Border.all()),
          child: Text(
            income.amount.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        title: Text(
          income.category.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          income.description.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}

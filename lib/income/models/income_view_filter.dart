import 'package:flutter_todos/backend/models/income.dart';

enum IncomeViewFilter { all, activeOnly, completedOnly }

extension IncomeViewFilterX on IncomeViewFilter {
  bool apply(Income income) {
    return true;
  }

  Iterable<Income> applyAll(Iterable<Income> income) {
    return income.where(apply);
  }
}

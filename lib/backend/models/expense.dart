import 'package:flutter_todos/backend/dto/expense_dto.dart';
import 'package:uuid/uuid.dart';

import '../helpers/json.dart';
import 'base_entity.dart';

const String tableExpenses = 'expenses';
var uuid = const Uuid();

class ExpenseFields {
  ExpenseFields._();

  static const String id = 'id';
  static const String category = 'category';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String deletedAt = 'deletedAt';
  static const String expenseDate = 'expenseDate';
}

class Expense extends Base {
  final String? id;
  final String category;
  final double amount;
  final String description;
  final DateTime expenseDate;

  const Expense._({
    this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.expenseDate,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  }) : super();

  static Expense mapExpenseFromDto(ExpenseDto expenseDto) {
    return Expense._(
        category: expenseDto.category,
        description: expenseDto.description,
        amount: expenseDto.amount,
        expenseDate: expenseDto.expenseDate);
  }

  factory Expense.fromJson(Map<String, Object?> json) => Expense._(
        id: json.parseString(ExpenseFields.id),
        category: json.parseString(ExpenseFields.category),
        description: json.parseString(ExpenseFields.description),
        amount: json.parseDouble(ExpenseFields.amount),
        createdAt: DateTime.tryParse(json.parseString(ExpenseFields.createdAt)),
        updatedAt: DateTime.tryParse(json.parseString(ExpenseFields.updatedAt)),
        deletedAt: DateTime.tryParse(json.parseString(ExpenseFields.deletedAt)),
        expenseDate:
            DateTime.tryParse(json.parseString(ExpenseFields.expenseDate)) ??
                DateTime.now(),
      );

  Map<String, Object?> toJsonCreate() => {
        ExpenseFields.id: uuid.v4(),
        ExpenseFields.category: category,
        ExpenseFields.description: description,
        ExpenseFields.amount: amount,
        ExpenseFields.createdAt: DateTime.now().toUtc().toString(),
        ExpenseFields.updatedAt: DateTime.now().toUtc().toString(),
        ExpenseFields.expenseDate: expenseDate.toString(),
      };

  Map<String, Object?> toJsonUpdate() => {
        ExpenseFields.id: id,
        ExpenseFields.category: category,
        ExpenseFields.description: description,
        ExpenseFields.amount: amount,
        ExpenseFields.createdAt: createdAt.toString(),
        ExpenseFields.updatedAt: DateTime.now().toUtc().toString(),
        ExpenseFields.expenseDate: expenseDate.toString(),
      };
}

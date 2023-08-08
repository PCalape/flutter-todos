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
}

class Expense extends Base {
  final String? id;
  final String category;
  final double amount;
  final String description;

  const Expense._({
    this.id,
    required this.category,
    required this.description,
    required this.amount,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  }) : super();

  static Expense mapExpenseFromDto(ExpenseDto expenseDto) {
    return Expense._(
        category: expenseDto.category,
        description: expenseDto.description,
        amount: expenseDto.amount);
  }

  factory Expense.fromJson(Map<String, Object?> json) => Expense._(
        id: json.parseString(ExpenseFields.id),
        category: json.parseString(ExpenseFields.category),
        description: json.parseString(ExpenseFields.description),
        amount: json.parseDouble(ExpenseFields.amount),
        createdAt: DateTime.tryParse(json.parseString(ExpenseFields.createdAt)),
        updatedAt: DateTime.tryParse(json.parseString(ExpenseFields.updatedAt)),
        deletedAt: DateTime.tryParse(json.parseString(ExpenseFields.deletedAt)),
      );

  Map<String, Object?> toJsonCreate() => {
        ExpenseFields.id: uuid.v4(),
        ExpenseFields.category: category,
        ExpenseFields.description: description,
        ExpenseFields.amount: amount,
        ExpenseFields.createdAt: DateTime.now().toUtc().toString(),
      };

  Map<String, Object?> toJsonUpdate() => {
        ExpenseFields.id: id,
        ExpenseFields.category: category,
        ExpenseFields.description: description,
        ExpenseFields.amount: amount,
        ExpenseFields.createdAt: createdAt.toString(),
        ExpenseFields.updatedAt: DateTime.now().toUtc().toString(),
      };
}

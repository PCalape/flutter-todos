import 'package:flutter_todos/backend/dto/income_dto.dart';
import 'package:uuid/uuid.dart';

import '../helpers/json.dart';
import 'base_entity.dart';

const String tableIncome = 'income';
var uuid = const Uuid();

class IncomeFields {
  IncomeFields._();

  static const String id = 'id';
  static const String category = 'category';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String deletedAt = 'deletedAt';
}

class Income extends Base {
  final String? id;
  final String category;
  final double amount;
  final String description;

  const Income._({
    this.id,
    required this.category,
    required this.description,
    required this.amount,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  }) : super();

  static Income mapIncomeFromDto(IncomeDto incomeDto) {
    return Income._(
        category: incomeDto.category,
        description: incomeDto.description,
        amount: incomeDto.amount);
  }

  factory Income.fromJson(Map<String, Object?> json) => Income._(
        id: json.parseString(IncomeFields.id),
        category: json.parseString(IncomeFields.category),
        description: json.parseString(IncomeFields.description),
        amount: json.parseDouble(IncomeFields.amount),
        createdAt: DateTime.tryParse(json.parseString(IncomeFields.createdAt)),
        updatedAt: DateTime.tryParse(json.parseString(IncomeFields.updatedAt)),
        deletedAt: DateTime.tryParse(json.parseString(IncomeFields.deletedAt)),
      );

  Map<String, Object?> toJsonCreate() => {
        IncomeFields.id: uuid.v4(),
        IncomeFields.category: category,
        IncomeFields.description: description,
        IncomeFields.amount: amount,
        IncomeFields.createdAt: DateTime.now().toUtc().toString(),
      };

  Map<String, Object?> toJsonUpdate() => {
        IncomeFields.id: id,
        IncomeFields.category: category,
        IncomeFields.description: description,
        IncomeFields.amount: amount,
        IncomeFields.createdAt: createdAt.toString(),
        IncomeFields.updatedAt: DateTime.now().toUtc().toString(),
      };
}

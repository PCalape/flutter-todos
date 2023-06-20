import 'package:uuid/uuid.dart';

import '../dto/account_dto.dart';
import '../helpers/json.dart';
import 'base_entity.dart';

const String tableAccounts = 'accounts';
var uuid = const Uuid();

class AccountFields {
  AccountFields._();

  static const String id = 'id';
  static const String name = 'name';
  static const String ownerId = 'ownerId';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String deletedAt = 'deletedAt';
}

class Account extends Base {
  final String? id;
  final String name;
  final String? ownerId;

  const Account._({
    this.id,
    required this.name,
    this.ownerId,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  }) : super();

  static Account mapAccountFromDto(AccountDto accountDto) {
    return Account._(name: accountDto.name, ownerId: accountDto.ownerId);
  }

  factory Account.fromJson(Map<String, Object?> json) => Account._(
        id: json.parseString(AccountFields.id),
        name: json.parseString(AccountFields.name),
        ownerId: json.parseString(AccountFields.ownerId),
        createdAt: DateTime.tryParse(json.parseString(AccountFields.createdAt)),
        updatedAt: DateTime.tryParse(json.parseString(AccountFields.updatedAt)),
        deletedAt: DateTime.tryParse(json.parseString(AccountFields.deletedAt)),
      );

  Map<String, Object?> toJsonCreate() => {
        AccountFields.id: uuid.v4(),
        AccountFields.name: name,
        AccountFields.ownerId: ownerId,
        AccountFields.createdAt: DateTime.now().toUtc().toString(),
      };
}

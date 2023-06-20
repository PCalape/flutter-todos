import 'package:uuid/uuid.dart';

import '../dto/user_dto.dart';
import '../helpers/json.dart';
import 'base_entity.dart';

const String tableUsers = 'users';
var uuid = const Uuid();

class UserFields {
  UserFields._();

  static const String id = 'id';
  static const String email = 'email';
  static const String name = 'name';
  static const String photo = 'photo';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String deletedAt = 'deletedAt';
}

class User extends Base {
  final String? id;
  final String email;
  final String name;
  final String? photo;

  const User._({
    this.id,
    required this.email,
    required this.name,
    this.photo,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  }) : super();

  static User mapUserFromDto(UserDto userDto) {
    return User._(
        email: userDto.email, name: userDto.name, photo: userDto.photo);
  }

  factory User.fromJson(Map<String, Object?> json) => User._(
        id: json.parseString(UserFields.id),
        email: json.parseString(UserFields.email),
        name: json.parseString(UserFields.name),
        photo: json.parseString(UserFields.photo),
        createdAt: DateTime.tryParse(json.parseString(UserFields.createdAt)),
        updatedAt: DateTime.tryParse(json.parseString(UserFields.updatedAt)),
        deletedAt: DateTime.tryParse(json.parseString(UserFields.deletedAt)),
      );

  Map<String, Object?> toJsonCreate() => {
        UserFields.id: uuid.v4(),
        UserFields.email: email,
        UserFields.name: name,
        UserFields.photo: photo,
        UserFields.createdAt: DateTime.now().toUtc().toString(),
      };
}

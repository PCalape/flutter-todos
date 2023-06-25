import 'package:uuid/uuid.dart';

import '../dto/todo_dto.dart';
import '../helpers/json.dart';
import 'base_entity.dart';

const String tableTodos = 'todos';
var uuid = const Uuid();

class TodoFields {
  TodoFields._();

  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String isCompleted = 'isCompleted';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String deletedAt = 'deletedAt';
}

class Todo extends Base {
  final String? id;
  final String title;
  final String description;
  final bool isCompleted;

  const Todo._({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  }) : super();

  static Todo mapTodoFromDto(TodoDto todoDto) {
    return Todo._(
        title: todoDto.title,
        description: todoDto.description,
        isCompleted: todoDto.isCompleted);
  }

  factory Todo.fromJson(Map<String, Object?> json) => Todo._(
        id: json.parseString(TodoFields.id),
        title: json.parseString(TodoFields.title),
        description: json.parseString(TodoFields.description),
        isCompleted: json.parseBool(TodoFields.isCompleted),
        createdAt: DateTime.tryParse(json.parseString(TodoFields.createdAt)),
        updatedAt: DateTime.tryParse(json.parseString(TodoFields.updatedAt)),
        deletedAt: DateTime.tryParse(json.parseString(TodoFields.deletedAt)),
      );

  Map<String, Object?> toJsonCreate() => {
        TodoFields.id: uuid.v4(),
        TodoFields.title: title,
        TodoFields.description: description,
        TodoFields.isCompleted: isCompleted,
        TodoFields.createdAt: DateTime.now().toUtc().toString(),
      };
}

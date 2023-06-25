import '../db_initialize/db_initialize.dart';
import '../models/todo.dart';

class TodoRepository {
  static final TodoRepository repository = TodoRepository._init();

  TodoRepository._init();

  Future<void> create(Todo todo) async {
    try {
      final db = await ExpensesDatabase.instance.database;
      await db.insert(tableTodos, todo.toJsonCreate());
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<Todo> fetchTodoById(String id) async {
    try {
      final db = await ExpensesDatabase.instance.database;
      List todo = await db.query(tableTodos, where: "id = ?", whereArgs: [id]);
      if (todo.isEmpty) throw Exception('Todo not found');
      return Todo.fromJson(todo[0]);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<List<Todo>> fetchAllTodos() async {
    try {
      final db = await ExpensesDatabase.instance.database;
      const orderBy = '${TodoFields.createdAt} DESC';
      final result = await db.query(tableTodos, orderBy: orderBy);
      return result.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      final db = await ExpensesDatabase.instance.database;
      await db.delete(tableTodos, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }
}

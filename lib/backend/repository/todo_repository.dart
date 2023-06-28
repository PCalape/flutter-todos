import 'package:rxdart/subjects.dart';

import '../db_initialize/db_initialize.dart';
import '../models/todo.dart';

class TodoRepository {
  static final TodoRepository repository = TodoRepository._init();

  TodoRepository._init() {
    fetchTodosForSeeding().then((todos) {
      _todoStreamController.add(todos);
    });
  }

  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  Stream<List<Todo>> fetchAllTodos() =>
      _todoStreamController.asBroadcastStream();

  Future<List<Todo>> fetchTodosForSeeding() async {
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

  Future<void> create(Todo todo) async {
    try {
      //data saving
      final db = await ExpensesDatabase.instance.database;
      await db.insert(tableTodos, todo.toJsonCreate());

      //stream update
      _todoStreamController.add([todo, ..._todoStreamController.value]);
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

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
      final db = await ExpensesDatabase.instance.database;
      Map<String, Object?> todoUpdate = todo.toJsonUpdate();
      Map<String, Object?> todoCreate = todo.toJsonCreate();
      final todos = [..._todoStreamController.value];

      //data saving
      List existingTodo =
          await db.query(tableTodos, where: 'id = ?', whereArgs: [todo.id]);
      if (existingTodo.isNotEmpty) {
        await db.update(tableTodos, todoUpdate,
            where: 'id = ?', whereArgs: [todo.id]);

        //stream update
        final todoIndex = todos.indexWhere((t) => t.id == todo.id);
        if (todoIndex >= 0) {
          todos[todoIndex] = Todo.fromJson(todoUpdate);
        } else {
          todos.insert(0, Todo.fromJson(todoUpdate));
        }
        _todoStreamController.add(todos);
      } else {
        await db.insert(tableTodos, todoCreate);

        //stream update
        todos.insert(0, Todo.fromJson(todoCreate));
        _todoStreamController.add(todos);
      }
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      final db = await ExpensesDatabase.instance.database;
      await db.delete(tableTodos, where: "id = ?", whereArgs: [id]);

      //stream update
      final todos = [..._todoStreamController.value];
      final todoIndex = todos.indexWhere((t) => t.id == id);
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> toggleCompletion(bool areAllCompleted) async {
    try {
      final db = await ExpensesDatabase.instance.database;
      if (!areAllCompleted) {
        await db.update(tableTodos, {'isCompleted': 1},
            where: 'isCompleted = 0');

        //stream update
        final allCompletedTodos = _todoStreamController.value.map((todo) {
          return Todo.fromJson({
            ...todo.toJsonUpdate(),
            'isCompleted': 1,
          });
        });
        _todoStreamController.add(allCompletedTodos.toList());
      } else {
        await db.update(tableTodos, {'isCompleted': 0},
            where: 'isCompleted = 1');

        //stream update
        final allCompletedTodos = _todoStreamController.value.map((todo) {
          return Todo.fromJson({
            ...todo.toJsonUpdate(),
            'isCompleted': 0,
          });
        });
        _todoStreamController.add(allCompletedTodos.toList());
      }
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> clearCompleted() async {
    try {
      final db = await ExpensesDatabase.instance.database;
      await db.delete(tableTodos, where: 'isCompleted = 1');

      //stream update
      final todos = [..._todoStreamController.value];
      todos.removeWhere((todo) => todo.isCompleted);
      _todoStreamController.add(todos);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }
}

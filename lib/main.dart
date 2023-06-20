import 'package:flutter/widgets.dart';
import 'package:flutter_todos/bootstrap.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';

import 'backend/db_initialize/db_initialize.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ExpensesDatabase.instance.database;

  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(todosApi: todosApi);
}

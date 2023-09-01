import 'package:flutter/widgets.dart';
import 'package:flutter_todos/bootstrap.dart';

import 'backend/db_initialize/db_initialize.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IncomeDatabase.instance.database;

  bootstrap();
}

import 'package:flutter_todos/backend/models/income.dart';
import 'package:rxdart/subjects.dart';

import '../db_initialize/db_initialize.dart';

class IncomeRepository {
  static final IncomeRepository repository = IncomeRepository._init();

  IncomeRepository._init() {
    fetchIncomeForSeeding().then((income) {
      _incomeStreamController.add(income);
    });
  }

  final _incomeStreamController =
      BehaviorSubject<List<Income>>.seeded(const []);

  Stream<List<Income>> fetchAllIncome() =>
      _incomeStreamController.asBroadcastStream();

  Future<List<Income>> fetchIncomeForSeeding() async {
    try {
      final db = await IncomeDatabase.instance.database;
      const orderBy = '${IncomeFields.updatedAt} DESC';
      final result = await db.query(tableIncome, orderBy: orderBy);
      return result.map((json) => Income.fromJson(json)).toList();
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> create(Income income) async {
    try {
      final db = await IncomeDatabase.instance.database;
      Map<String, Object?> incomeUpdate = income.toJsonUpdate();
      Map<String, Object?> incomeCreate = income.toJsonCreate();
      final allIncome = [..._incomeStreamController.value];

      //data saving
      List existingIncome =
          await db.query(tableIncome, where: 'id = ?', whereArgs: [income.id]);
      if (existingIncome.isNotEmpty) {
        await db.update(tableIncome, incomeUpdate,
            where: 'id = ?', whereArgs: [income.id]);

        //stream update
        final incomeIndex = allIncome.indexWhere((t) => t.id == income.id);
        if (incomeIndex >= 0) {
          allIncome[incomeIndex] = Income.fromJson(incomeUpdate);
        } else {
          allIncome.insert(0, Income.fromJson(incomeUpdate));
        }
        _incomeStreamController.add(allIncome);
      } else {
        await db.insert(tableIncome, incomeCreate);

        //stream update
        allIncome.insert(0, Income.fromJson(incomeCreate));
        _incomeStreamController.add(allIncome);
      }
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      final db = await IncomeDatabase.instance.database;
      await db.delete(tableIncome, where: "id = ?", whereArgs: [id]);

      //stream update
      final income = [..._incomeStreamController.value];
      final incomeIndex = income.indexWhere((t) => t.id == id);
      income.removeAt(incomeIndex);
      _incomeStreamController.add(income);
    } catch (e) {
      print(e);
      throw new Exception(e);
    }
  }
}

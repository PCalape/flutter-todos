import '../db_initialize/db_initialize.dart';
import '../models/account.dart';

class AccountService {
  static final AccountService service = AccountService._init();

  AccountService._init();

  Future<void> create(String ownerId, Account account) async {
    final db = await IncomeDatabase.instance.database;
    await checkIfAccountExists(ownerId, account.name);
    await db.insert(tableAccounts, account.toJsonCreate());
  }

  Future<List<Account>> fetchAllAccounts() async {
    final db = await IncomeDatabase.instance.database;
    const orderBy = '${AccountFields.createdAt} DESC';
    final result = await db.query(tableAccounts, orderBy: orderBy);
    return result.map((json) => Account.fromJson(json)).toList();
  }

  Future<void> checkIfAccountExists(String ownerId, String name) async {
    final db = await IncomeDatabase.instance.database;
    List account = await db.query(tableAccounts,
        where: "name = ?1 AND ownerId = ?2", whereArgs: [name, ownerId]);
    if (account.isNotEmpty) throw Exception('Account already exists');
  }
}

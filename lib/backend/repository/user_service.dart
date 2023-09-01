import '../db_initialize/db_initialize.dart';
import '../models/user.dart';

class UserService {
  static final UserService service = UserService._init();

  UserService._init();

  Future<void> create(User user) async {
    final db = await IncomeDatabase.instance.database;
    await checkIfUserExists(user.email);
    await db.insert(tableUsers, user.toJsonCreate());
  }

  Future<User> fetchUserByEmail(String email) async {
    final db = await IncomeDatabase.instance.database;
    List user =
        await db.query(tableUsers, where: "email = ?", whereArgs: [email]);
    if (user.isEmpty) throw Exception('User not found');
    return User.fromJson(user[0]);
  }

  Future<List<User>> fetchAllUsers() async {
    final db = await IncomeDatabase.instance.database;
    const orderBy = '${UserFields.createdAt} DESC';
    final result = await db.query(tableUsers, orderBy: orderBy);
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<void> checkIfUserExists(String idOrEmail) async {
    final db = await IncomeDatabase.instance.database;
    List user = await db.query(tableUsers,
        where: "email = ? OR id = ?", whereArgs: [idOrEmail]);
    if (user.isNotEmpty) throw Exception('User already exists');
  }
}

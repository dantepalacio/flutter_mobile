import 'package:last/database/user_database.dart';
import 'package:last/models/user_model.dart';
import 'package:last/api_connection/api_connection.dart';
import 'package:last/models/api_models.dart';

class UserDao {
  final dbProvider = DatabaseProvider.dbProvider;
  final tokenDbProvider = TokenDBProvider.dbProvider;

  Future<int> createUser(User user) async {
    final db = await dbProvider.database;

    var result = db.insert(userTable, user.toDatabaseJson());
    return result;
  }

  Future<int> deleteUser(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(userTable, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<bool> checkUser(int id) async {
    final db = await dbProvider.database;
    try {
      List<Map> users =
          await db.query(userTable, where: 'id = ?', whereArgs: [id]);
      if (users.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<User?> getUserById(int id) async {
    final db = await dbProvider.database;
    try {
      List<Map> users =
          await db.query(userTable, where: 'id = ?', whereArgs: [id]);
      if (users.length > 0) {
        return User.fromDatabaseJson(users.first);
      }
    } catch (error) {
      return null;
    }
  }

  Future<String?> getUserToken(int id) async {
    final db = await dbProvider.database;
    try {
      var res = await db.rawQuery("SELECT token FROM userTable WHERE id=0");
      return res.isNotEmpty ? (User.fromDatabaseJson(res.first)).token : null;
    } catch (err) {
      return null;
    }
  }

  Future<int> createToken(
      {required String username, required String password}) async {
    final db = await dbProvider.database;
    UserLogin userLogin = UserLogin(username: username, password: password);
    Token token = await getToken(userLogin);

    final tokenDb = token.token;
    final data = {'refresh': tokenDb, 'access': tokenDb};
    var result = db.insert(TokenTable, data);
    return result;
  }

  Future<List<Map<String, dynamic>>?> checkTokens() async {
    final db = await tokenDbProvider.database;
    print('TOKEEEEEEEEEEEEEN ${db.query(TokenTable)}');
    return db.query(TokenTable);
  }

  Future<int> addTokenToDb(String token, String refreshToken) async {
    final db = await tokenDbProvider.database;

    final data = {'access': token, 'refresh': refreshToken};
    final userTable = 'users';
    int lastId = await db.insert(userTable, data);

    return lastId;
  }
}

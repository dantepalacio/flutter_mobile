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

  Future<List<Map>> getUserToken() async {
    final db = await dbProvider.database;
      var res = await db.query("users");
      return res;
    
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
    return db.query(TokenTable);
  }

  //добавляет наш токен в базу
  Future<int> addTokenToDb(String token, String refreshToken) async {
    final db = await tokenDbProvider.database;

    final data = {'access': token, 'refresh': refreshToken};
    final userTable = 'users';
    int lastId = await db.insert(userTable, data);

    return lastId;
  }
}

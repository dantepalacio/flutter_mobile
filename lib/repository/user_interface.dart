import 'package:last/models/user_model.dart';
import 'package:last/models/api_models.dart';

abstract class IUserRepository {
  Future<List<User>> getAll();

  Future<User?> getOne(int id);

  Future<bool> register(String email, String username, String password);

  Future<String> login(String username, String password);

  Future<void> update(User user);

  Future<void> delete(int id);
}

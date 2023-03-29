import 'package:last/models/api_models.dart';
import 'package:last/models/article_model.dart';
import 'package:last/models/user_model.dart';
import 'package:last/repository/article_repository.dart';
import 'package:last/repository/user_repository.dart';

class HomeController {
  UserRepository _userRepo = UserRepository();

  Future<bool> registerUser(
      String email, String username, String password) async {
    return await _userRepo.register(email, username, password);
  }

  Future<String> loginUser(String username, String password) async {
    return await _userRepo.login(username, password);
  }

  Future<void> removeBook(int id) {
    return _userRepo.delete(id);
  }
}

import 'dart:async';
import 'dart:convert';
// import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:last/dao/dao.dart';
import 'package:last/models/user_model.dart';
import 'package:last/models/api_models.dart';
import 'package:last/api_connection/api_connection.dart';
import 'package:last/repository/user_interface.dart';

class UserRepository implements IUserRepository {
  final userDao = UserDao();

  UserRepository();

  Future<User> signInWithCredentials({
    required String username,
    required String password,
  }) async {
    UserLogin userLogin = UserLogin(username: username, password: password);
    Token token = await getToken(userLogin);
    User user = User(
      id: 0,
      username: username,
      token: token.token,
    );

    print("HELLO FROM API ${username} ${password}");

    await userDao.createUser(user);
    return user;
  }

  // Future<void> signUp(
  //     {required String userName,
  //     required String firstName,
  //     required String lastName,
  //     required String email,
  //     required String password,
  //     required String streetAddress,
  //     required String locality,
  //     required String city,
  //     required String state,
  //     required int pinCode}) async {
  //   UserDetails userDetails = UserDetails(
  //       username: userName,
  //       firstName: firstName,
  //       lastName: lastName,
  //       email: email,
  //       password: password);

  //   Address address = Address(
  //       streetAddress: streetAddress,
  //       locality: locality,
  //       city: city,
  //       state: state,
  //       pinCode: pinCode);

  //   UserSignup userSignup = UserSignup(user: userDetails, address: address);

  //   UserLogin registeredUser = await registerUser(userSignup);
  //   Token registeredUserToken = await getToken(registeredUser);
  //   User user = User(
  //     id: 0,
  //     username: userName,
  //     token: registeredUserToken.token,
  //   );
  //   await userDao.createUser(user);
  // }

  Future<void> deleteToken({required int id}) async {
    await userDao.deleteUser(id);
  }

  Future<void> signOut() async {
    print("Logging out");
    await deleteToken(id: 0);
  }

  Future<bool> hasToken() async {
    bool result = await userDao.checkUser(0);
    return result;
  }

  Future<bool> isSignedIn() async {
    return hasToken();
  }

  Future<String> getUser() async {
    User? user = await userDao.getUserById(0);
    return user!.username;
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<User?> getOne(int id) {
    // TODO: implement getOne
    throw UnimplementedError();
  }

  @override
  Future<bool> register(String email, String username, String password) async {
    // TODO: implement insert
    UserRegister userRegister =
        UserRegister(email: email, username: username, password: password);
    Future<bool> success = registerApi(userRegister);

    return success;
  }

  @override
  Future<String> login(String username, String password) async {
    // TODO: implement insert

    UserLogin userLogin = UserLogin(username: username, password: password);
    int userID = await loginApi(userLogin);
    print("USERIIIIIIIIIIIIIID: ${userID}");
    if (userID != 0) {
      var session = FlutterSession();
      session.set('token', username);
      session.set('userID', userID);
    }

    return userID.toString();
  }



  @override
  Future<void> update(User user) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

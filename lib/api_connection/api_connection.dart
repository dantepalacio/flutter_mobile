import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:last/dao/dao.dart';
import 'package:last/models/api_models.dart';
import 'package:last/models/article_model.dart';
import 'package:last/models/detail_article_model.dart';

final _base = "http://192.168.0.8:8000";
final _getArticlesURL = "/api-arcticles/";
final _getDetailURL = '/api-detail/';
final _signInURL = "/token/";
final _signUpEndpoint = "/api/register/";
final _sessionEndpoint = "main/api/token/refresh/";
// final _graphParamEndpoint = "/api/get_states/";
final _tokenURL = _base + _signInURL;
final _signUpURL = _base + _signUpEndpoint;
final _createSessionURL = _base + _sessionEndpoint;
// final _graphParamURL = _base + _graphParamEndpoint;
final _adminUsername = 'admin';
final _adminPassword = 'admin';

Future<Token> getToken(UserLogin userLogin) async {
  final http.Response response = await http.post(
    Uri.parse(_tokenURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    return Token.fromJson(json.decode(response.body));
  } else {
    print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  }
}

Future<bool> registerApi(UserRegister userRegister) async {
  Future<bool> success = Future.value(false);
  final http.Response response = await http.post(
    Uri.parse(_signUpURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userRegister.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    success = Future.value(true);
  } else {
    // print(json.decode(response.body).toString());
    // throw Exception(json.decode(response.body));
  }

  return success;
}

Future<int> loginApi(UserLogin userLogin) async {
  int userID = 0;

  // блок http-запроса
  final http.Response response = await http.post(
    Uri.parse(_tokenURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );

  if (response.statusCode == 200) {
    Token token = Token.fromJson(json.decode(response.body));
    Map<String, dynamic> userCreds = token.fetchUser(token.token);

    UserDao userDao = UserDao();
    userDao.addTokenToDb(token.token, token.refreshToken);
    // print("INNNNNNNNNNNNN: ${userDao.getUserToken()}");
    var users = await userDao.getUserToken();
    // users.forEach((row) => {print(row)});

    userID = userCreds.values.last;
    print("YYYYYYYYY: ${userID}");
    return userID;
  } else {
    throw Exception(json.decode(response.body));
  }
}

class ArticleService {
  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(_base + _getArticlesURL));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      print("EEEEEEEEEEE:     ${body}");
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw "Не удалось загрузить данные";
    }
  }

  Future<Article> fetchDetail(String articleID) async {
    final response =
        await http.get(Uri.parse(_base + _getDetailURL + articleID));
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      print("DETAILLLLL:  ${body}");
      Article detail = Article.fromJson(body);
      return detail;
    } else {
      throw "Не удалось загрузить detail данные";
    }
  }
}

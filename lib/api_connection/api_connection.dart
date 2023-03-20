import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:last/dao/dao.dart';
import 'package:last/models/api_models.dart';
import 'package:last/models/article_model.dart';

final _base = "http://192.168.0.8:8000";
final _getArticlesURL = "/api-arcticles/";
final _signInURL = "/token/";
final _signUpEndpoint = "/api/register/";
final _sessionEndpoint = "/token/refresh/";
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

    userID = userCreds.values.last;
    return userID;
  } else {
    throw Exception(json.decode(response.body));
  }
}

Future<List<Article>> fetchArticles() async {
  final http.Response response = await http
      .get(Uri.parse(_base + _getArticlesURL), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'datatype': 'json',
  });
  if (response.statusCode == 200) {
    List<dynamic> articlesJson = jsonDecode(response.body);
    List<Article> articles = <Article>[];
    articlesJson.forEach((element) {
      articles.add(Article(
          author: element['author'].toString(),
          date: element['date'],
          id: 1,
          name: element['name'],
          text: element['text']));
    });

    return articles;
  } else {
    throw Exception(json.decode(response.body));
  }
}

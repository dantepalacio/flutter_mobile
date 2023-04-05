import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:last/api_connection/token_refresher.dart';
import 'package:last/dao/dao.dart';
import 'package:last/models/api_models.dart';
import 'package:last/models/article_model.dart';
import 'package:last/models/detail_article_model.dart';
import 'package:last/pages/articles_page.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _base = "http://192.168.0.8:8000";

final _getArticlesURL = "/api-arcticles/";
final _getDetailURL = '/api-detail/';
final _createArticle = '/api-create/';
final _getCommentsURL = '/api-comments/';

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

    final data = json.decode(response.body);
    final accessToken = data['access'];
    final refreshToken = data['refresh'];

    UserPreferences.accessToken = accessToken;
    UserPreferences.refreshToken = refreshToken;
    // final rfr = UserPreferences.refreshToken;
    // final acs = UserPreferences.accessToken;

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

  Future<List<Article>> fetchComments(String articleID) async {
    final response =
        await http.get(Uri.parse(_base + _getCommentsURL + articleID));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      print("COMMEEEEEEEEEEEnTS:  ${body}");
      List<Article> comments =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      return comments;
    } else {
      throw "нк удалось загрузить комменты";
    }
  }
}

// Future<void> createArticle(ArticleCreate article) async {
//   final Dio dio = Dio();
//   final String token = UserPreferences.accessToken;

//   final Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $token',
//   };
//   var asd = jsonEncode(article.toJson());
//   var qwe = UserPreferences.userId;
//   print('FFFFFFFFFFFFFFFFFFFFFFFASASASAS$asd');
//   print('AAAAAAAAAAAAAAAAAAAAAAAAAAAQWWWWWWWW $qwe');

//   // final http.Response response = await http.post(
//   //   Uri.parse(_base + _createArticle),
//   //   headers: headers,
//   //   body: jsonEncode(article.toJson()),
//   // );
//   final url = _base + _createArticle;
//   final response = await dio.post(url,
//       data: jsonEncode(article.toJson()), options: Options(headers: headers));

//   if (response.statusCode == 201) {
//     print('Article created successfully.');
//   }

//   else {
//     throw Exception('Failed to create article.');
//   }
// }

Future<void> createArticle(ArticleCreate article) async {
  final dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  dio.interceptors.add(TokenInterceptor(dio, prefs));
  TokenInterceptor _tokenInterceptor = TokenInterceptor(dio, prefs);

  final url = _base + _createArticle;

  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await dio.post(
      url,
      data: jsonEncode(article.toJson()),
      options: Options(headers: headers),
    );

    if (response.statusCode == 201) {
      print('успех');
    } else {
      throw Exception('ошибка api_connection');
    }
  } on DioError catch (e) {
    if (e.response?.statusCode == 401) {
      print('ошибка 401 API_CONNECTION');
      await _tokenInterceptor.refreshAccessToken(prefs);
      createArticle(article);
    } else {
      throw Exception('Exception ошибка api_connection');
    }
  }
}

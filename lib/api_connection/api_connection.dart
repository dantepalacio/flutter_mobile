import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:last/api_connection/token_refresher.dart';
import 'package:last/dao/dao.dart';
import 'package:last/models/api_models.dart';
import 'package:last/models/article_model.dart';
import 'package:last/models/detail_article_model.dart';
import 'package:last/models/profile_model.dart';
import 'package:last/pages/articles_page.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _base = "http://192.168.0.8:8000";

final _getArticlesURL = "/api-arcticles/";
final _getDetailURL = '/api-detail/';
final _createArticle = '/api-create/';
final _getCommentsURL = '/article_comments/';
final _likeURL = '/api-like/';
final _setLikeURL = '/api-setLike/';
final _deleteLikeURL = '/delete_like/';

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
    print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
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
      Article detail = Article.fromJson(body);
      return detail;
    } else {
      throw "Не удалось загрузить detail данные";
    }
  }

  Future<List<Comments>> fetchComments(String articleID) async {
    final response =
        await http.get(Uri.parse(_base + _getCommentsURL + articleID));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      List<Comments> _comms =
          body.map((dynamic item) => Comments.fromJson(item)).toList();

      // return comments;
      return _comms;
    } else {
      throw "нк удалось загрузить комменты";
    }
  }
}

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

Future<void> createComment(String articleId, String text) async {
  Map<String, dynamic> userCreds =
      JwtDecoder.decode(UserPreferences.accessToken);
  var userId = userCreds.values.last;

  print('IDDDDDDDDDDDDDDDDDDD $userId');

  final response = await http.post(
    Uri.parse(_base + '/create_comment/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'arcticle': articleId,
      'author': userId,
      'text': text,
    }),
  );

  if (response.statusCode == 201) {
    print('Комментарий создан');
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}

Future<bool> createLike(String articleId) async {
  final dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  dio.interceptors.add(TokenInterceptor(dio, prefs));
  TokenInterceptor _tokenInterceptor = TokenInterceptor(dio, prefs);
  final token = UserPreferences.accessToken;
  Map<String, dynamic> userCreds =
      JwtDecoder.decode(UserPreferences.accessToken);
  var userIdd = userCreds.values.last;
  final http.Response response = await http.post(
    Uri.parse(_base + _setLikeURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: jsonEncode({'user_id': userIdd, 'arcticle_id': articleId}),
  );

  if (response.statusCode == 201) {
    return true;
  }
  if (response.statusCode == 401) {
    print('LIKE 401');
    _tokenInterceptor.refreshAccessToken(prefs);
    createLike(articleId);
    return false;
  } else {
    return false;
  }
}

Future<List<Like>> getLikes(articleId) async {
  final dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  dio.interceptors.add(TokenInterceptor(dio, prefs));
  TokenInterceptor _tokenInterceptor = TokenInterceptor(dio, prefs);
  final token = UserPreferences.accessToken;
  Map<String, dynamic> userCreds =
      JwtDecoder.decode(UserPreferences.accessToken);
  var userIdd = userCreds.values.last;

  final http.Response response = await http.get(
    Uri.parse(_base + _likeURL + '?arcticle=$articleId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final likesList =
        (jsonResponse as List).map((data) => Like.fromJson(data)).toList();

    // SHARED PREF LIKES
    UserPreferences.likesCount = likesList.length;
    print('ASASSSSSSSSS $likesList');
    return likesList;
  } else {
    throw Exception('ОШибка при загрузке лайков');
  }
}

Future<bool> deleteLike(String articleId) async {
  final dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  dio.interceptors.add(TokenInterceptor(dio, prefs));
  TokenInterceptor _tokenInterceptor = TokenInterceptor(dio, prefs);
  final token = UserPreferences.accessToken;
  Map<String, dynamic> userCreds =
      JwtDecoder.decode(UserPreferences.accessToken);
  var userIdd = userCreds.values.last;

  final http.Response response = await http.delete(
    Uri.parse(_base + _deleteLikeURL + articleId + '/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: jsonEncode({'user_id': userIdd, 'pk': articleId}),
  );

  if (response.statusCode == 204) {
    print('ЛАЙК УДАЛЕН');
    return true;
  }
  if (response.statusCode == 401) {
    print('LIKE DELETE 401');
    _tokenInterceptor.refreshAccessToken(prefs);
    deleteLike(articleId);
    return false;
  } else {
    return false;
  }
}

Future<bool> checkIfLiked(String articleId) async {
  final dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  dio.interceptors.add(TokenInterceptor(dio, prefs));
  final token = UserPreferences.accessToken;
  Map<String, dynamic> userCreds =
      JwtDecoder.decode(UserPreferences.accessToken);
  var userIdd = userCreds.values.last;

  final http.Response response = await http.get(
    Uri.parse(_base + _likeURL + '?user=$userIdd&arcticle=$articleId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> likes = jsonDecode(response.body);
    return likes.isNotEmpty;
  } else {
    throw Exception('Failed to load likes');
  }
}

// Создание профиля
Future<Profile> createProfile(Map<String, dynamic> profileData) async {
  late final Dio dio;
  late final SharedPreferences prefs;
  dio = Dio();
  prefs = await SharedPreferences.getInstance();
  TokenInterceptor _refresher = TokenInterceptor(dio, prefs);
  // final token = _refresher.getAccessToken();
  final token = UserPreferences.accessToken;
  print(jsonEncode(profileData));
  final response = await http.post(
    Uri.parse(_base + '/profiles/create/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(profileData),
  );
  if (response.statusCode == 201) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return Profile.fromJson(jsonResponse);
  } else if (response.statusCode == 401) {
    _refresher.refreshAccessToken(prefs);
    return createProfile(profileData);
  } else {
    throw Exception('Failed to create profile');
  }
}

// Получение профиля по ID
Future<Profile> fetchProfile(String id) async {
  final response = await http.get(Uri.parse(_base + '/profiles/$id/'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return Profile.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load profile');
  }
}

// Обновление профиля
Future<Profile> updateProfile(
    String id, Map<String, dynamic> profileData) async {
  final response = await http.put(
    Uri.parse(_base + 'edit/$id/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(profileData),
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return Profile.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to update profile');
  }
}

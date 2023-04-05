import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:last/dao/dao.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// final Dio dio = Dio();

class TokenInterceptor extends Interceptor {
  final Dio dio;
  final SharedPreferences prefs;

  TokenInterceptor(this.dio, this.prefs);

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String accessToken = await getAccessToken();
    var test = UserPreferences.accessToken;
    print('ACCESSSS DIO $accessToken');
    options.headers['Authorization'] = 'Bearer $accessToken';
    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    print('ASASASASAIOWYQ*GHEUWYIQU');
    if (err.response?.statusCode == 401) {
      await refreshAccessToken(prefs);
      String accessToken = await getAccessToken();
      // перезапуск запроса с новым токеном
      RequestOptions newOptions = err.requestOptions
          .copyWith(headers: {'Authorization': 'Bearer $accessToken'});
      return dio.request(err.requestOptions.path,
          options: Options(
              method: newOptions.method,
              headers: newOptions.headers,
              contentType: newOptions.contentType,
              responseType: newOptions.responseType,
              validateStatus: newOptions.validateStatus),
          data: err.response?.data,
          queryParameters: newOptions.queryParameters);
    }
    return super.onError(err, handler);
  }

  bool isRefreshingToken = false;
  Future<String> getAccessToken() async {
    String accessToken = prefs.getString('access_token');
    print('ASASASASASA $accessToken');
    if (accessToken != null) {
      Map<String, dynamic> payload = json.decode(ascii
          .decode(base64.decode(base64.normalize(accessToken.split(".")[1]))));
      int expiryTime = payload["exp"];
      if (DateTime.fromMillisecondsSinceEpoch(expiryTime * 1000)
          .isBefore(DateTime.now())) {
        if (!isRefreshingToken) {
          // проверяем, что обновление токена не выполняется в данный момент
          isRefreshingToken = true; // устанавливаем флаг
          await refreshAccessToken(prefs);
          isRefreshingToken = false; // сбрасываем флаг
        }
        accessToken = prefs.getString('access_token');
      }
      return accessToken;
    } else {
      throw Exception('access токен не найден');
    }
  }

  // Future<void> refreshAccessToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String refreshToken = prefs.getString('refresh_token');
  //   print('REFRESH TOKEN_REFRESHER $refreshToken');
  //   var response = await dio.post(
  //     'http://192.168.0.8:8000/token/refresh/',
  //     options: Options(contentType: 'application/json; charset=UTF-8'),
  //     data: {'refresh': refreshToken},
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = response.data;
  //     print('DATA ACESSSSSS $data');
  //     await prefs.setString('access_token', data['access_token']);
  //   } else {
  //     throw Exception('Ощибка в загрузке рефреш токена');
  //   }
  // }
  Future<void> refreshAccessToken(SharedPreferences prefs) async {
    String refreshToken = prefs.getString('refresh_token');
    print('REFRESH TOKEN_REFRESHER $refreshToken');
    var response = await dio.post(
      'http://192.168.0.8:8000/token/refresh/',
      options: Options(contentType: 'application/json; charset=UTF-8'),
      data: {'refresh': refreshToken},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      print('DATA ACESSSSSS $data');
      await prefs.setString('access_token', data['access']);
    } else {
      throw Exception('Ощибка в загрузке рефреш токена');
    }
  }
}

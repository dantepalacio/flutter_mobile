import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:last/api_connection/push_service.dart';
import 'package:last/api_connection/token_refresher.dart';
import 'package:last/controllers/home_controller.dart';
import 'package:last/dao/dao.dart';
import 'package:last/models/api_models.dart';
import 'package:last/pages/register_page.dart';
import 'package:last/pages/reset_password_page.dart';
import 'package:last/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last/api_connection/api_connection.dart';
import 'package:last/repository/user_repository.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// dio.interceptors.add(TokenInterceptor(dio, prefs));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  final prefs = await SharedPreferences.getInstance();
  final Dio dio = Dio();
  // TokenInterceptor _tokenInterceptor = TokenInterceptor(dio,prefs);
  dio.interceptors.add(TokenInterceptor(dio, prefs));
  runApp(MyApp());

  PushService().connect();
}

class UserData {
  String username;
  String password;

  UserData({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class Token {
  String token;

  Token({required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();

  // создаем объект контроллера
  final HomeController _homeController = HomeController();
}

class _LoginDemoState extends State<LoginDemo> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // NotificationService.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Авторизация"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // #1 asset for my pics
            // Padding(
            //   padding: const EdgeInsets.only(top: 60.0),
            //   child: Center(
            //     child: Container(
            //         width: 200,
            //         height: 150,
            //         /*decoration: BoxDecoration(
            //             color: Colors.red,
            //             borderRadius: BorderRadius.circular(50.0)),*/
            //         child: Image.asset('../asset/images/flutter-logo.png')),
            //   ),
            // ),
            Container(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(top: 70.0),

              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Имя пользователя',
                    hintText: 'Введите верное имя пользователя'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Пароль',
                    hintText: 'Введите ваш пароль'),
                validator: MultiValidator([
                  RequiredValidator(errorText: "* Required"),
                  MinLengthValidator(6,
                      errorText: "Password should be atleast 6 characters"),
                  MaxLengthValidator(15,
                      errorText:
                          "Password should not be greater than 15 characters")
                ]),
              ),
            ),
            TextButton(
              onPressed: () {
                // UserRepository userRepository = UserRepository();
                // userRepository.signInWithCredentials(
                //     username: usernameController.text,
                //     password: passwordController.text);
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => ResetPage()));

                // NotificationService.showBigTextNotification(
                //     title: "AZAZA",
                //     body: "AZAZAZAZAAZA",
                //     fln: flutterLocalNotificationsPlugin);
              },
              child: const Text(
                'Забыли пароль?',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String userCreds = await widget._homeController
                      .loginUser(username, password);

                  // UserLogin userLogin =
                  //     UserLogin(username: username, password: password);
                  // print('TOKEN LOGIN ${getToken(userLogin)}');
                  // UserData userData = UserData(
                  //   username: usernameController.text,
                  //   password: passwordController.text,
                  // );
                  // String jsonBody = json.encode(userData);

                  // final response = await http.post(
                  //   Uri.parse('http://192.168.0.8:8000/token/'),
                  //   headers: <String, String>{
                  //     'Authorization':
                  //         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc2ODc4NjgyLCJpYXQiOjE2NzY4NzgzODIsImp0aSI6IjA5YzI5ZmNjY2FjMzQwMjE5NzcxZWY3ZWY4ZjQ3NjBkIiwidXNlcl9pZCI6MTV9.uZ9yYGeRJ6nAYhkdOHBBGwmBU9fQTEYIH7B9WjIULXc',
                  //     'Content-Type': 'application/json; charset=UTF-8',
                  //   },
                  //   body: jsonBody,
                  // );

                  // if (response.statusCode == 200) {
                  // } else {}
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                name: '',
                                sessionId: '',
                              )));
                },
                child: Text(
                  'Вход',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Container(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RegisterPage()));
                },
                child: Text(
                  'Нет аккаунта? Зарегистрироваться',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'login_page.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:convert';
import 'package:last/repository/user_repository.dart';
import 'package:last/controllers/home_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();

  final HomeController _homeController = HomeController();
}

// void main(List<String> args) async {
//   AuthService authService = AuthService();
//   var responseBody = await authService.registration(
//       'anuar_test', 'test@mail.ru', 'anuar123', 'anuar123');
//   print(responseBody);
// }

// class AuthService {
//   final registrationUri = Uri.parse('http://192.168.0.8:8000/api/register/');

//   Future<String> registration(
//       String username, String email, String password1, String password2) async {
//     var response = await http.post(registrationUri, body: {
//       'username': username,
//       'email': email,
//       'password1': password1,
//       'password2': password2,
//     });
//     return response.body;
//   }
// }

class UserData {
  String username;
  String email;
  String password1;
  String password2;

  UserData(
      {required this.username,
      required this.email,
      required this.password1,
      required this.password2});

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password1': password1,
        'password2': password2,
      };
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Регистрация"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(top: 50.0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Придумайте имя',
                  hintText: 'Введите имя',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(top: 15.0),
              child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Введите почту',
                      hintText:
                          'Введите настоящую почту  (пример:abc@gmail.com)'),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Необходимо"),
                    EmailValidator(errorText: "Введите настоящую почту"),
                  ])),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: password1Controller,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Придумайте пароль',
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
            Container(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: password2Controller,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Повторите ввод пароля',
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
            Container(
              margin: const EdgeInsets.only(top: 25.0),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  String username = usernameController.text;
                  String email = emailController.text;
                  String password = password1Controller.text;
                  bool success = await widget._homeController
                      .registerUser(email, username, password);
                  // UserData userData = UserData(
                  //   username: usernameController.text,
                  //   email: emailController.text,
                  //   password1: password1Controller.text,
                  //   password2: password2Controller.text,
                  // );
                  // String jsonBody = json.encode(userData);

                  // final response = await http.post(
                  //   Uri.parse('http://192.168.0.8:8000/api/register/'),
                  //   headers: <String, String>{
                  //     'Content-Type': 'application/json; charset=UTF-8',
                  //   },
                  //   body: jsonEncode(<String, String>{
                  //     'username': usernameController.text,
                  //     'email': emailController.text,
                  //     'password': password1Controller.text,
                  //   }),
                  // );
// await Future.value(true)
                  if (success == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => LoginDemo()));
                  } else {}
                },
                child: Text(
                  'Зарегистрироваться',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

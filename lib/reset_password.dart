import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'login.dart';
import 'HomePage.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Сброс пароля"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(top: 20.0),
              child: const Text(
                'Для сброса пароля необходимо ввести зарегистрированный email, на который вышлется письмо о сбросе',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(top: 15.0),
              child: TextFormField(
                  decoration: const InputDecoration(
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
              margin: const EdgeInsets.only(top: 25.0),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage(name: '', sessionId: '',)));
                },
                child: const Text(
                  'Сбросить',
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

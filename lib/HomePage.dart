import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ануар ФОрум'),
      ),
      body: Center(
          child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 20.0, left: 35.0),
            height: 80,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginDemo()));
              },
              child: Text(
                'Вход',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            margin: const EdgeInsets.only(left: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RegisterPage()));
              },
              child: Text(
                'Регистрация',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      )),
    );
  }
}

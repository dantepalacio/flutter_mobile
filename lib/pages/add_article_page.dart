import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
// import 'package:flutter_session/flutter_session.dart';
import 'login_page.dart';
import 'register_page.dart';

import 'package:last/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AddArticlePage extends StatefulWidget {
  AddArticlePage({Key? key});

  @override
  Add_ArticlePageState createState() => Add_ArticlePageState();
}

class Add_ArticlePageState extends State<AddArticlePage> {
  Add_ArticlePageState();

  @override
  void initState() {
    _fetchSession();
  }

  int _currentIndex = 0;
  String _username = "";
  String _userID = "";

  Future<void> _fetchSession() async {
    _username = await FlutterSession().get('username');
    _userID = await FlutterSession().get('userID').toString();
  }

  void onTabTapped(int index) {
    setState(() async {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Добавление статьи'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                // BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
              child: const Text('Выйти'))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            height: 80,
            width: 150,
            margin: const EdgeInsets.only(left: 20.0, top: 20),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Сохранить',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      )),
    );
  }
}

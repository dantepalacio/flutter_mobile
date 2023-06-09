import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:last/pages/add_article_page.dart';
import 'package:last/pages/articles_page.dart';
import 'package:last/pages/show_profile_page.dart';
// import 'package:flutter_session/flutter_session.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'create_profile_page.dart';

import 'package:last/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:last/dao/dao.dart';

// import 'package:covid_communiquer/repository/chat_repository.dart';

// import 'graph_space.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String sessionId;

  HomePage({Key? key, required this.name, required this.sessionId});

  @override
  _HomePageState createState() =>
      _HomePageState(name: name, sessionId: sessionId);
}

class _HomePageState extends State<HomePage> {
  final String name;
  final String sessionId;
  _HomePageState({required this.name, required this.sessionId});

  int _currentIndex = 0;
  String _username = "";
  String _userID = "";
  final usernameTest = UserPreferences.username;
  final userID = UserPreferences.userId;

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
        title: const Text('Ануар Форум'),
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
          // FutureBuilder(
          //   future: FlutterSession().get('token'),
          //   builder: (context, snapshot) {
          //   return Text(snapshot.hasData ? snapshot.data : 'Loading...');
          // }),
          // ignore: avoid_unnecessary_containers
          Container(
            child: Text('Добро пожаловать $usernameTest'), // ${widget.username}
          ),
          Container(
            margin: const EdgeInsets.only(right: 20.0, left: 35.0, top: 20),
            height: 80,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginDemo()));
              },
              child: const Text(
                'Вход',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            margin: const EdgeInsets.only(left: 20.0, top: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RegisterPage()));
              },
              child: const Text(
                'Регистрация',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            margin: const EdgeInsets.only(left: 20.0, top: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ArticleList()));
              },
              child: const Text(
                'Список статей',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            margin: const EdgeInsets.only(left: 20.0, top: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ArticleForm()));
              },
              child: const Text(
                'Создать статью',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            margin: const EdgeInsets.only(left: 20.0, top: 20),
            child: ElevatedButton(
              onPressed: () {
                // UserPreferences.clearPreferences();
                print('LSKFJKLJSXKLMFFFF $usernameTest');

                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CreateProfilePage()));
              },
              child: const Text(
                'Создать профиль',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 80,
            width: 150,
            margin: const EdgeInsets.only(left: 20.0, top: 20),
            child: ElevatedButton(
              onPressed: () {
                var decodedToken =
                    JwtDecoder.decode(UserPreferences.accessToken);

                var userIDD = decodedToken.values.last;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfilePage(
                              userId: userIDD.toString(),
                            )));
              },
              child: const Text(
                'Профиль',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:last/controllers/article_controller.dart';
import 'package:last/controllers/home_controller.dart';
import 'package:last/models/article_model.dart';
import 'package:last/pages/add_article_page.dart';
import 'package:last/pages/detail_article.dart';
// import 'package:flutter_session/flutter_session.dart';
import '../api_connection/api_connection.dart';
import 'login_page.dart';
import 'register_page.dart';

import 'package:last/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ArticleList extends StatefulWidget {
  ArticleController _articleController = ArticleController();
  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    widget._articleController.fetchArticles().then((articles) {
      print("FFFFFFFF:  ${articles}");
      setState(() {
        _articles = articles;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Список статей"),
      ),
      body: ListView.builder(
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return ListTile(
            title: Text(article.name),
            subtitle: Text(
              article.text,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            trailing: const Icon(Icons.arrow_forward_rounded),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailArticle(
                            articleID: article.id,
                          )));
            },
          );
        },
      ),
    );
  }
}


 


// class ListViewHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         ListTile(
//             title: Text("Battery Full"),
//             subtitle: Text("The battery is full."),
//             leading: CircleAvatar(backgroundImage: AssetImage("assets/js.png")),
//             trailing: Icon(Icons.star)),
//       ],
//     );
//   }
// }

// class ArticlesPage extends StatefulWidget {
//   ArticlesPage({Key? key});

//   final HomeController _homeController = HomeController();

//   @override
//   _ArticlesPageState createState() => _ArticlesPageState();
// }

// class _ArticlesPageState extends State<ArticlesPage> {
//   _ArticlesPageState();

//   late List<Article> _articles;
//   late List<Widget> _articlesListView = [];

//   @override
//   void initState() {
//     _fetchArticles();
//   }

//   List<Widget> bindArticles() async {
//     List<Widget> articlesListView = <Widget>[];
//     _articles = await widget._homeController.fetchArticles().then((value) => 
//       value.forEach((element) {
//         articlesListView.add(
//           ListTile(
//               title: Text(element.name),
//               subtitle: Text(element.text),
//               leading: CircleAvatar(backgroundImage: AssetImage("assets/js.png")),
//               trailing: Icon(Icons.star)),
//         );
//       });
//     );

//     return articlesListView;
//   }

//   Future<List<Article>> _fetchArticles() async {
//     _articles = await widget._homeController.fetchArticles();

//     _articlesListView = bindArticles();

//     return _articles;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.amber,
//         title: const Text('Ануар Форум'),
//         actions: <Widget>[
//           TextButton(
//               onPressed: () {
//                 // BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
//               },
//               child: const Text('Выйти'))
//         ],
//       ),
//       body: Container(
//           child: Column(
//         children: <Widget>[
//           Expanded(
//               child: ListView(
//             padding: const EdgeInsets.all(8),
//             children: _articlesListView,
//           )),
//           Container(
//             height: 80,
//             width: 150,
//             margin: const EdgeInsets.only(left: 20.0, top: 20),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (_) => AddArticlePage()));
//               },
//               child: const Text(
//                 'Добавить статью',
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           )
//         ],
//       )),
//     );
//   }
// }

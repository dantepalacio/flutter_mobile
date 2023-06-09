import 'package:flutter/material.dart';
import 'package:last/controllers/article_controller.dart';
import 'package:last/controllers/home_controller.dart';
import 'package:last/models/article_model.dart';
import 'package:last/pages/add_article_page.dart';
import 'package:last/pages/detail_article.dart';
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

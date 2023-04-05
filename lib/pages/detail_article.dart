import 'package:flutter/material.dart';
import 'package:last/controllers/article_controller.dart';
import 'package:last/controllers/home_controller.dart';
import 'package:last/models/article_model.dart';
import 'package:last/models/detail_article_model.dart';
import 'package:last/pages/add_article_page.dart';
import '../api_connection/api_connection.dart';
import 'login_page.dart';
import 'register_page.dart';

import 'package:last/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DetailArticle extends StatefulWidget {
  final String articleID;
  ArticleController _articleController = ArticleController();

  DetailArticle({required this.articleID});

  @override
  _DetailArticleState createState() =>
      _DetailArticleState(articleID: articleID);
}

class _DetailArticleState extends State<DetailArticle> {
  Article? _details;
  Comments? _comments;
  final String articleID;

  List<Widget> art = [];
  List<Widget> artCom = [];

  _DetailArticleState({required this.articleID});

  @override
  void initState() {
    super.initState();
    fetchComments(articleID);
    fetchDetails(articleID);
  }

  Future<List<Widget>> fetchDetails(String articleID) async {
    art = await widget._articleController.fetchDetail(articleID).then((detail) {
      return <Widget>[
        Container(
          child: Text(detail.name),
        ),
        Container(
          child: Text(detail.author),
        ),
        Container(
          child: Text(detail.date),
        ),
        Container(
          child: Text(detail.text),
        ),
      ];
      // setState(() {
      //   _details = detail;
      // });
    });

    print("FFFFFFF:    ${art}");

    return art;
  }

  Future<List<Widget>> fetchComments(String articleID) async {
    artCom = await widget._articleController
        .fetchComments(articleID)
        .then((comments) {
      return <Widget>[
        Container(
          child: Text(comments.author),
        ),
        Container(
          child: Text(comments.date),
        ),
        Container(
          child: Text(comments.text),
        ),
      ];
      // setState(() {
      //   _details = detail;
      // });
    });

    print("COMMENTSSS DETAIL_ARTICLE:    ${artCom}");

    return artCom;
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: Text("Статья"),
  //       ),
  //       body: Container(
  //         child: Column(children: fetchDetails(articleID)),
  //       ),
  //     ),
  //   );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Статья"),
        ),
        body: FutureBuilder<List<Widget>>(
          future: fetchDetails(articleID), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  children: snapshot.data!,
                ),
              );
            } else {
              return Text("Error: ${snapshot.error}");
            }
          },
        ),
      ),
    );
  }
}

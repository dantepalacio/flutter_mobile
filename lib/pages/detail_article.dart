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
  final String articleID;
  int _likes = 0;
  TextEditingController CommentTextController = TextEditingController();

  @override
  void dispose() {
    CommentTextController.dispose();
    super.dispose();
  }

  void _submitComment() {
    print('ARTCILE IDDDD $articleID');
    createComment(articleID, CommentTextController.text);
    CommentTextController.clear();
  }

  void _toggleLike() async {
    await createLike(articleID);
    getLikes().then((likes) {
      setState(() {
        _likes = likes.length;
      });
    });
  }

  List<Widget> art = [];
  late List<Comments> artCom = [];

  _DetailArticleState({required this.articleID});

  @override
  void initState() {
    super.initState();
    fetchDetails(articleID);
    getLikes().then((likes) {
      setState(() {
        _likes = likes.length;
      });
    });
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
    });

    return art;
  }

  Future<List<Comments>> fetchComments(String articleID) async {
    var artCom = await widget._articleController.fetchComments(articleID);

    print("COMMENTSSS DETAIL_ARTICLE:    ${artCom}");
    return artCom;
  }

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
        body: Column(
          children: [
            FutureBuilder<List<Widget>>(
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
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    bool success = await createLike(articleID);
                    if (success) {
                      setState(() {
                        _likes++;
                      });
                    }
                  },
                  icon: Icon(Icons.thumb_up),
                ),
                Text(_likes.toString()),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: CommentTextController,
                    decoration: InputDecoration(
                      hintText: "Введите комментарий",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitComment,
                ),
              ],
            ),
            Flexible(
              flex: 2,
              child: FutureBuilder<List<Comments>>(
                future: fetchComments(articleID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].author),
                            subtitle: Text(snapshot.data![index].text),
                            onTap: () {},
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("Error: ${snapshot.error}");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text("Статья"),
//       ),
//       body: 
//       Column(children: [
//         FutureBuilder<List<Widget>>(
//           future: fetchDetails(articleID),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (snapshot.hasData) {
//               return Container(
//                 child: Column(
//                   children: snapshot.data!,
//                 ),
//               );
//             } else {
//               return Text("Error: ${snapshot.error}");
//             }
//           },
//         ),
//         Flexible(
//           flex: 2,
//           child: FutureBuilder<List<Comments>>(
//             future: fetchComments(articleID),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               if (snapshot.hasData) {
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       child: ListTile(
//                         title: Text(snapshot.data![index].author),
//                         subtitle: Text(snapshot.data![index].text),
//                         onTap: () {},
//                       ),
//                     );
//                   },
//                 );
//               } else {
//                 return Text("Error: ${snapshot.error}");
//               }
//             },
//           ),
//         )
//       ]),
//     ));
//   }
// }
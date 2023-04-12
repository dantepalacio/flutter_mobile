import 'package:flutter/material.dart';
import 'package:last/api_connection/api_connection.dart';
import 'package:last/models/article_model.dart';
import 'package:last/pages/articles_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'package:intl/intl.dart';

import 'package:last/dao/dao.dart';

class ArticleForm extends StatefulWidget {
  const ArticleForm({Key? key}) : super(key: key);

  @override
  _ArticleFormState createState() => _ArticleFormState();
}

class _ArticleFormState extends State<ArticleForm> {
  late TextEditingController _nameController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание статьи'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Введите название статьи',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Введите текст',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final article = ArticleCreate(
                  name: _nameController.text,
                  text: _textController.text,
                  // date: formatted,
                );
                var access = UserPreferences.accessToken;
                var refresh = UserPreferences.refreshToken; //cxvxcv
                print('ACCESS add_article_page $access');
                print('REFRESH add_article_page $refresh');
                var qwe = UserPreferences.userId;
                print('SHARED IDDDD add_article_page $qwe');
                createArticle(article);
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ArticleList()));
              },
              child: const Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }
}

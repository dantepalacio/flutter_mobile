import 'package:last/api_connection/api_connection.dart';
import 'package:last/models/article_model.dart';
import 'package:last/repository/article_interface.dart';

class ArticleRepository implements IArticleRepository {
  @override
  Future<List<Article>> getAll() async {
    var articles = fetchArticles();
    return articles;
  }
}

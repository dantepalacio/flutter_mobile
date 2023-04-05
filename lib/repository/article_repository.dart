import 'package:last/api_connection/api_connection.dart';
import 'package:last/models/article_model.dart';
import 'package:last/repository/article_interface.dart';

class ArticleRepository implements IArticleRepository {
  ArticleService _articleService = ArticleService();
  @override
  Future<List<Article>> getAll() async {
    var articles = _articleService.fetchArticles();
    return articles;
  }

  @override
  Future<Article> fetchDetail(String articleID) async {
    var articles = _articleService.fetchDetail(articleID);
    return articles;
  }

  @override
  Future<List<Article>> fetchComments(String articleID) async {
    var comments = _articleService.fetchComments(articleID);
    return comments;
  }
}

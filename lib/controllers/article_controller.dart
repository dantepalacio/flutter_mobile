import 'package:last/models/api_models.dart';
import 'package:last/models/article_model.dart';
import 'package:last/models/user_model.dart';
import 'package:last/repository/article_repository.dart';
import 'package:last/repository/user_repository.dart';

class ArticleController {
  ArticleRepository _articleRepo = ArticleRepository();

  Future<List<Article>> fetchArticles() {
    return _articleRepo.getAll();
  }

  Future<Article> fetchDetail(String articleID) {
    return _articleRepo.fetchDetail(articleID);
  }
}

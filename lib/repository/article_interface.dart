import 'package:last/models/article_model.dart';

abstract class IArticleRepository {
  Future<List<Article>> getAll();
}

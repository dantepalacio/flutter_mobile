import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:last/dao/dao.dart';

class Article {
  final String id;
  final String name;
  final String text;
  final String author;
  final String date;

  Article({
    required this.id,
    required this.name,
    required this.text,
    required this.author,
    required this.date,
  });

  factory Article.fromJson(Map<dynamic, dynamic> json) {
    return Article(
      id: json['id'].toString(),
      name: json['name'].toString(),
      text: json['text'].toString(),
      author: json['author'].toString(),
      date: json['date'].toString(),
    );
  }

  Object? toJson() {}
}

class ArticleCreate {
  // Map<String, dynamic> userCreds =
  //     JwtDecoder.decode(UserPreferences.accessToken);
  final String name;
  final String text;

  ArticleCreate({required this.name, required this.text});

  Map<String, dynamic> toJson() => {
        'name': name,
        'text': text,
        'author': UserPreferences.userId, //userCreds.values.last
      };

}

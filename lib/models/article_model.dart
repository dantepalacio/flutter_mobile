import 'dart:convert';

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
}

import 'dart:convert';

class Detail {
  late final String id;
  late final String name;
  late final String text;
  late final String author;
  late final String date;

  Detail({
    required this.id,
    required this.name,
    required this.text,
    required this.author,
    required this.date,
  });

  factory Detail.fromJson(Map<dynamic, dynamic> json) {
    return Detail(
      id: json['id'].toString(),
      name: json['name'].toString(),
      text: json['text'].toString(),
      author: json['author'].toString(),
      date: json['date'].toString(),
    );
  }
}

class Comments {
  final String id;
  final String date;
  final String text;
  final String arcticle;
  final String author;

  Comments({
    required this.id,
    required this.date,
    required this.text,
    required this.arcticle,
    required this.author,
  });

  factory Comments.fromJson(Map<dynamic, dynamic> json) {
    return Comments(
      id: json['id'].toString(),
      date: json['date'].toString(),
      text: json['text'].toString(),
      arcticle: json['arcticle'].toString(),
      author: json['author'].toString(),
    );
  }
}

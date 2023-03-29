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

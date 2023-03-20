class Article {
  late int id;
  late String name;
  late String date;
  late String text;
  late String author;

  Article({
    required this.id,
    required this.name,
    required this.date,
    required this.text,
    required this.author,
  });

  factory Article.fromJson(Map<dynamic, dynamic> data) => Article(
        id: data['id'],
        name: data['name'],
        date: data['date'],
        text: data['text'],
        author: data['author'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        'id': this.id,
        'name': this.name,
        'date': this.date,
        'text': this.text,
        'author': this.author,
      };

  // List<Article> fromJsonToList(Map<dynamic, dynamic> json) => {
  //   var articles = List<Article>();
  //   json.forEach((column, value) {
  //     articles.add(Article(
  //       id
  //       name
  //       date
  //       text
  //       author
  //     ))
  //   })
  // };
}

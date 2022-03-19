import 'dart:convert';

class News {
  int? id;

  String name;

  String author;

  String title;

  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  News({
    this.id = 0,
    required this.name,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      name: map['source']['name'],
      author: map['author'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      publishedAt:
          DateTime.parse(map['publishedAt'] ?? DateTime.now().toString()),
      content: map['content'],
    );
  }

  factory News.fromFirebase(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      name: map['name'],
      author: map['author'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      publishedAt:
          DateTime.parse(map['publishedAt'] ?? DateTime.now().toString()),
      content: map['content'],
    );
  }
}

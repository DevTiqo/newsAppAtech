import 'dart:convert';

class News {
  int id;

  String name;

  int price;

  int available;

  String category;

  String photo;

  News({
    required this.id,
    required this.name,
    required this.price,
    required this.available,
    this.category = "",
    this.photo = "",
  });

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      category: map['category'] ?? '',
      available: map['available'],
      photo: map['photo'] ?? '',
    );
  }
}

class User {
  int id;

  String name;

  String email;

  String phone;

  String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.token = "",
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user']['id'],
      name: map['user']['name'],
      email: map['user']['email'],
      phone: map['user']['phone'],
      token: map['token'],
    );
  }
}

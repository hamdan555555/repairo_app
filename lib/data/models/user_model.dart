class User {
  final String id;
  final String name;
  final String token;

  User({required this.id, required this.name, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      token: json['token'],
    );
  }
}

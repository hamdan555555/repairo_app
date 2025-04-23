class SignupUser {
  final String id;
  final String name;
  final String token;

  SignupUser({required this.id, required this.name, required this.token});

  factory SignupUser.fromJson(Map<String, dynamic> json) {
    return SignupUser(
      id: json['id'].toString(),
      name: json['name'],
      token: json['token'],
    );
  }
}

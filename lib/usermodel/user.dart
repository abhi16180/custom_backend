class User {
  final String? username;
  final String? email;

  User({required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(username: jsonData['username'], email: jsonData['email']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email};
  }
}

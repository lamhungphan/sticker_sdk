class User {
  User({required this.name, required this.avatar, required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      id: json['id'],
    );
  }

  final String name;
  final String avatar;
  final String id;
}

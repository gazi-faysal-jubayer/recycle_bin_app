class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final double recyclePoints;
  final List<String> favoriteCategories;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.recyclePoints,
    required this.favoriteCategories,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      recyclePoints: json['recyclePoints'].toDouble(),
      favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'recyclePoints': recyclePoints,
      'favoriteCategories': favoriteCategories,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
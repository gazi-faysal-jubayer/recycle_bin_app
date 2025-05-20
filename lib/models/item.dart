class RecycleItem {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String userId;
  final List<String> imageUrls;
  final bool isRecyclable;
  final String recyclableType; // plastic, paper, metal, glass, etc.
  final double estimatedValue;
  final DateTime createdAt;

  RecycleItem({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.userId,
    required this.imageUrls,
    required this.isRecyclable,
    required this.recyclableType,
    required this.estimatedValue,
    required this.createdAt,
  });

  factory RecycleItem.fromJson(Map<String, dynamic> json) {
    return RecycleItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['categoryId'],
      userId: json['userId'],
      imageUrls: List<String>.from(json['imageUrls']),
      isRecyclable: json['isRecyclable'],
      recyclableType: json['recyclableType'],
      estimatedValue: json['estimatedValue'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'userId': userId,
      'imageUrls': imageUrls,
      'isRecyclable': isRecyclable,
      'recyclableType': recyclableType,
      'estimatedValue': estimatedValue,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
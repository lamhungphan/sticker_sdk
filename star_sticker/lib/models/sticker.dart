class Sticker {
  final String id;
  final String categoryId;
  final String imagePath;
  final bool isPremium;
  final String status; // 'active', 'inactive', 'pending', 'deleted'
  final int usedCount;
  final List<String> tags;

  const Sticker({
    required this.id,
    required this.categoryId,
    required this.imagePath,
    required this.isPremium,
    required this.status,
    required this.usedCount,
    required this.tags,
  });

  factory Sticker.fromJson(Map<String, dynamic> json) {
    return Sticker(
      id: json['id'].toString(),
      categoryId: json['category_id'].toString(),
      imagePath: json['image_path'] as String,
      isPremium: json['is_premium'] as bool? ?? false,
      status: json['status'] as String? ?? 'active',
      usedCount: json['used_count'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'image_path': imagePath,
      'is_premium': isPremium,
      'status': status,
      'used_count': usedCount,
      'tags': tags,
    };
  }

  // Helper to check if sticker is active
  bool get isActive => status == 'active';

  get category => null;

  get name => null;
}

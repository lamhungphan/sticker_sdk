class Category {
  final String id;
  final String name;
  final String imagePath;
  final double price;

  const Category({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] as String,
      imagePath: json['image_path'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_path': imagePath,
      'price': price,
    };
  }
}
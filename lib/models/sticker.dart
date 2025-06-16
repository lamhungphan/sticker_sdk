class Sticker {
  const Sticker({
    required this.path,
    required this.type,
    required this.isPro,
    required this.id,
  });

  factory Sticker.fromJson(Map<String, Object?> json) {
    return Sticker(
      path: json['path'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isPro: json['isPro'] as bool? ?? false,
      id: json['id'] as String,
    );
  }

  final String id;
  final String path;
  final String type;
  final bool isPro;
}

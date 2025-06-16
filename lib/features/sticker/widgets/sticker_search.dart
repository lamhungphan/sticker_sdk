import "package:flutter/material.dart";

class StickerSearch extends StatelessWidget {
  final List<String> types;
  final Function(String matchedType) onMatched;
  final Function() onEmpty;

  const StickerSearch({
    super.key,
    required this.types,
    required this.onMatched,
    required this.onEmpty,
  });

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 40,
      child: TextFormField(
        onChanged: (String query) {
          if (query.trim().isEmpty) {
            onEmpty();
          } else {
            final match = types.firstWhere(
              (type) {
                final words = type.toLowerCase().split(RegExp(r'\s+'));
                return words.any((word) => word.contains(query.toLowerCase()));
              },
              orElse: () => '',
            );

            if (match.isNotEmpty) {
              onMatched(match);
            }
          }
        },
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: screenSize * 0.01),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          hintText: 'Search stickers',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: screenSize * 0.03),
            child: const Icon(Icons.search),
          ),
          prefixIconConstraints: const BoxConstraints(),
        ),
      ),
    );
  }
}

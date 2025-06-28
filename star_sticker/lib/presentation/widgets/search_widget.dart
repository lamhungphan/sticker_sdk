import "package:flutter/material.dart";
import "package:star_sticker/models/category.dart";

class SearchWidget extends StatelessWidget {
  final List<String> categories;
  final List<Category> categoriesName;
  final Function(String matchedType) onMatched;
  final Function() onEmpty;

  const SearchWidget({
    super.key,
    required this.categories,
    required this.categoriesName,
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
          print('search query: ' + query);
          if (query.trim().isEmpty) {
            onEmpty();
            print('onEmpty' + onEmpty.toString());
          } else {
            final match = categories.firstWhere(
              (cate) {
                print('cate: ' + cate);
                String name = '';
                for (var i = 0; i < categoriesName.length; i++) {
                  if (cate == categoriesName[i].id) {
                    name = categoriesName[i].name;
                    break;
                  }
                }
                final words = name.toLowerCase().split(RegExp(r'\s+'));
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

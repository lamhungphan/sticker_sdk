import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_sticker/presentation/provider/sticker_provider.dart';
import 'package:star_sticker/utils/thumb_update.dart';
import 'package:star_sticker/models/category.dart';
import 'package:star_sticker/models/sticker.dart';

// ignore: must_be_immutable
class CategoryWidget extends StatefulWidget {
  final Category category;

  CategoryWidget({
    super.key,
    required this.modalSetState,
    required this.scrollController,
    required this.category,
    required this.stickerCount,
    required this.showCount,
    required this.isRecentSelected,
    required this.thumbList,
    required this.onCategoryChanged,
  });

  StateSetter modalSetState;
  ScrollController scrollController;
  int stickerCount;
  bool showCount;
  bool isRecentSelected;
  List<Sticker> thumbList;
  Function(String) onCategoryChanged;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.005),
        child: GestureDetector(
          onTap: () {
            widget.isRecentSelected = widget.category.name == 'Recents';

            widget.category.name != 'Recents'
                ? setState(() {
                    updateThumbnail(stickerThumb: widget.thumbList, stickerType: widget.category.id);
                  })
                : widget.isRecentSelected = true;

            widget.modalSetState(() {
              widget.onCategoryChanged(widget.category.id);
              widget.scrollController.jumpTo(0);
            });
          },
          child: Consumer<StickerProvider>(
            builder: (context, provider, _) {
              final categoryName = provider.categoryMap[widget.category.id]?.name ?? widget.category.name;

              return widget.showCount
                  ? Text('$categoryName (${widget.stickerCount})', style: const TextStyle(fontSize: 20))
                  : Row(
                      children: [
                        Text(categoryName, style: const TextStyle(fontSize: 20)),
                        if (categoryName != 'Recents') const Icon(Icons.chevron_right),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

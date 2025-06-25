import 'package:flutter/material.dart';
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
    required this.onStickerTypeChanged,
  });

  StateSetter modalSetState;
  ScrollController scrollController;
  int stickerCount;
  bool showCount;
  bool isRecentSelected;
  List<Sticker> thumbList;
  Function(String) onStickerTypeChanged;

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
                  updateThumbnail(stickerThumb: widget.thumbList, stickerType: widget.category.name);
                })
                : widget.isRecentSelected = true;

            widget.modalSetState(() {
              widget.onStickerTypeChanged(widget.category.name);
              widget.scrollController.jumpTo(0);
            });
          },
          child:
              widget.showCount
                  ? Text('${widget.category.name} (${widget.stickerCount})', style: const TextStyle(fontSize: 20))
                  : Row(
                    children: [
                      Text(widget.category.name, style: const TextStyle(fontSize: 20)),
                      if (widget.category.name != 'Recents') const Icon(Icons.chevron_right),
                    ],
                  ),
        ),
      ),
    );
  }
}

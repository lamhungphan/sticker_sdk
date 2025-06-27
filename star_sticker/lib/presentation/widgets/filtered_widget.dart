import 'package:flutter/material.dart';
import 'package:star_sticker/presentation/widgets/grid_widget.dart';
import 'package:star_sticker/presentation/widgets/category_widget.dart';
import 'package:star_sticker/models/category.dart';
import 'package:star_sticker/models/sticker.dart';

// ignore: must_be_immutable
class FilteredWidget extends StatefulWidget {
  FilteredWidget({
    super.key,
    required this.currentStickerType,
    required this.allStickerList,
    required this.scrollController,
    required this.modalSetState,
    required this.isRecentSelected,
    required this.thumbList,
    required this.recentsStickerList,
    required this.allStickerPro,
    required this.onStickerTypeChanged,
  });

  String currentStickerType;
  Map<String, List<Sticker>> allStickerList;
  ScrollController scrollController;
  StateSetter modalSetState;
  bool isRecentSelected;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
  Map<String, List<Sticker>> allStickerPro;
  Function(String) onStickerTypeChanged;

  @override
  State<FilteredWidget> createState() => _FilteredWidgetState();
}

class _FilteredWidgetState extends State<FilteredWidget> {
  @override
  Widget build(BuildContext context) {
    final Map<String, List<Sticker>> filteredStickers =
        // Nếu thumb được chọn là Recents
        (widget.currentStickerType == 'Recents')
        // Thì lấy tất cả các loại Sticker
        ? Map<String, List<Sticker>>.fromEntries(widget.allStickerList.entries.take(5))
        // Còn không thì lấy tất cả Sticker của 1 loại Sticker
        : <String, List<Sticker>>{widget.currentStickerType: widget.allStickerList[widget.currentStickerType] ?? []};

    return Expanded(
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: filteredStickers.entries
            .expand((entry) {
              // Lấy key là loại của Sticker
              final String category = entry.key;
              // Lấy value là tất cả các Sticker
              final List<Sticker> stickers = (widget.currentStickerType == 'Recents')
                  ? entry.value.take(5).toList()
                  : entry.value;

              return stickers.isNotEmpty
                  ? [
                      CategoryWidget(
                        modalSetState: widget.modalSetState,
                        scrollController: widget.scrollController,
                        category: Category(id: category, name: category, imagePath: '', price: 0),
                        stickerCount: entry.value.length,
                        showCount: false,
                        isRecentSelected: widget.isRecentSelected,
                        thumbList: widget.thumbList,
                        onCategoryChanged: (String newType) {
                          setState(() {
                            widget.currentStickerType = newType;
                            widget.isRecentSelected = newType == 'Recents';
                          });

                          // Để trả về widget cha 1 String
                          widget.onStickerTypeChanged(newType);
                        },
                      ),
                      GridWidget(
                        stickers: stickers,
                        category: Category(id: category, name: category, imagePath: category, price: 0),
                        scrollController: widget.scrollController,
                        isViewOnly: widget.currentStickerType == 'Recents' ? true : false,
                        isLocked: true,
                        thumbList: widget.thumbList,
                        recentsStickerList: widget.recentsStickerList,
                        allStickerPro: widget.allStickerPro,
                        showLockIcon: true,
                      ),
                    ]
                  : [];
            })
            .cast<Widget>()
            .toList(),
      ),
    );
  }
}

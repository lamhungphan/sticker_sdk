import 'package:flutter/material.dart';
import 'package:star_sticker/presentation/widgets/grid_widget.dart';
import 'package:star_sticker/presentation/widgets/search_widget.dart';
import 'package:star_sticker/presentation/widgets/category_widget.dart';
import 'package:star_sticker/models/category.dart';
import 'package:star_sticker/models/sticker.dart';

// ignore: must_be_immutable
class ShopWidget extends StatefulWidget {
  ShopWidget({
    super.key,
    required this.modalSetState,
    required this.scrollController,
    required this.allStickerPro,
    required this.isRecentSelected,
    required this.thumbList,
    required this.recentsStickerList,
    required this.allcategory,
  });
  StateSetter modalSetState;
  ScrollController scrollController;
  Map<String, List<Sticker>> allStickerPro;
  bool isRecentSelected;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
  List<Category> allcategory = [];

  @override
  State<ShopWidget> createState() => _ShopWidgetState();
}

class _ShopWidgetState extends State<ShopWidget> {
  String? _matchedStickerType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.modalSetState(() {
          widget.scrollController.jumpTo(0);
        });
        _buildShopStickerUI(widget.scrollController);
      },
      child: const Icon(Icons.add_shopping_cart, size: 25),
    );
  }

  Future _buildShopStickerUI(ScrollController scrollController) {
    return showModalBottomSheet(
      useSafeArea: true,
      // Bo tròn góc
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // Độ dày viền
        side: const BorderSide(width: 0.5),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext statefulBuilderContext, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
              child: Column(
                children: [
                  _topShopStickerUI(modalContext, modalSetState),
                  Expanded(child: _shopStickerList(modalSetState, scrollController, _matchedStickerType)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _topShopStickerUI(BuildContext modalContext, StateSetter modalSetState) {
    final double screenSize = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(top: screenSize * 0.01, bottom: screenSize * 0.005, right: screenSize * 0.01),
            child: SearchWidget(
              categories: widget.allStickerPro.keys.toList(),
              categoriesName: widget.allcategory,
              onMatched: (matchedType) {
                modalSetState(() {
                  _matchedStickerType = matchedType;
                });
              },
              onEmpty: () {
                modalSetState(() {
                  _matchedStickerType = null;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _shopStickerList(StateSetter modalSetState, ScrollController scrollController, [String? matchedStickerType]) {
    return CustomScrollView(
      controller: scrollController,
      slivers:
          widget.allStickerPro.entries
              .where(
                (entry) => entry.key != 'Recents' && (matchedStickerType == null || entry.key == matchedStickerType),
              )
              .expand((entry) {
                // Lấy key là loại của Sticker
                final String category = entry.key;
                // Lấy value là tất cả các Sticker
                final List<Sticker> stickers = entry.value.take(5).toList();
                // Nếu sticker rỗng, trả rỗng
                return stickers.isNotEmpty
                    ? [
                      CategoryWidget(
                        modalSetState: modalSetState,
                        scrollController: scrollController,
                        category: Category(id: category, name: category, imagePath: '', price: 0),
                        stickerCount: entry.value.length,
                        showCount: true,
                        isRecentSelected: widget.isRecentSelected,
                        thumbList: widget.thumbList,
                        // isViewOnly: true,
                        onCategoryChanged: (_) {},
                      ),
                      GridWidget(
                        stickers: stickers,
                        category: Category(id: category, name: category, imagePath: '', price: 0),
                        scrollController: scrollController,
                        isViewOnly: false,
                        isLocked: true,
                        thumbList: widget.thumbList,
                        recentsStickerList: widget.recentsStickerList,
                        allStickerPro: widget.allStickerPro,
                        showLockIcon: false,
                      ),
                    ]
                    : [];
              })
              .cast<Widget>()
              .toList(),
    );
  }
}

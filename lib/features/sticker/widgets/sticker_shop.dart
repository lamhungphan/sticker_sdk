import 'package:flutter/material.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_grid.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_show_type.dart';
import 'package:sticker_app/models/chat_content.dart';
import 'package:sticker_app/models/sticker.dart';

// ignore: must_be_immutable
class StickerShop extends StatefulWidget {
  StickerShop({
    super.key,
    required this.modalSetState,
    required this.scrollController,
    required this.allStickerPro,
    required this.isRecentSelected,
    required this.thumbList,
    required this.recentsStickerList,
    required this.chatContentList,
  });
  StateSetter modalSetState;
  ScrollController scrollController;
  Map<String, List<Sticker>> allStickerPro;
  bool isRecentSelected;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
  List<ChatContent> chatContentList;

  @override
  State<StickerShop> createState() => _StickerShopState();
}

class _StickerShopState extends State<StickerShop> {
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
          builder: (
            BuildContext statefulBuilderContext,
            StateSetter modalSetState,
          ) {
            return Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.015,
              ),
              child: Column(
                children: [
                  _topShopStickerUI(modalContext),
                  Expanded(
                    child: _shopStickerList(modalSetState, scrollController),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _topShopStickerUI(BuildContext modalContext) {
    final double screenSize = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
              top: screenSize * 0.01,
              bottom: screenSize * 0.005,
              right: screenSize * 0.01,
            ),
            // child: const StickerSearch(),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Đóng modal khi nhấn Done
            Navigator.pop(modalContext);
          },
          child: const Text(
            'Done',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _shopStickerList(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    return CustomScrollView(
      controller: scrollController,
      slivers:
          widget.allStickerPro.entries
              .where((entry) => entry.key != 'Recents')
              .expand((entry) {
                // Lấy key là loại của Sticker
                final String stickerType = entry.key;
                // Lấy value là tất cả các Sticker
                final List<Sticker> stickers = entry.value.take(5).toList();
                // Nếu sticker rỗng, trả rỗng
                return stickers.isNotEmpty
                    ? [
                      StickerShowType(
                        modalSetState: modalSetState,
                        scrollController: scrollController,
                        stickerType: stickerType,
                        stickerCount: entry.value.length,
                        showCount: true,
                        isRecentSelected: widget.isRecentSelected,
                        thumbList: widget.thumbList,
                        isViewOnly: true,
                        onStickerTypeChanged: (_) {},
                      ),
                      StickerGrid(
                        stickers: stickers,
                        stickerType: stickerType,
                        scrollController: scrollController,
                        isViewOnly: false,
                        isLocked: false,
                        thumbList: widget.thumbList,
                        recentsStickerList: widget.recentsStickerList,
                        chatContentList: widget.chatContentList,
                        allStickerPro: widget.allStickerPro,
                      ),
                    ]
                    : [];
              })
              .cast<Widget>()
              .toList(),
    );
  }
}

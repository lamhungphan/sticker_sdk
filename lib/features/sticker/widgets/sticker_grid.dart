import 'package:flutter/material.dart';
import 'package:sticker_app/core/utils/sticker_builder.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_shop_detail.dart';
import 'package:sticker_app/models/chat_content.dart';
import 'package:sticker_app/models/sticker.dart';

// ignore: must_be_immutable
class StickerGrid extends StatefulWidget {
  StickerGrid({
    super.key,
    required this.stickers,
    required this.stickerType,
    required this.scrollController,
    required this.isViewOnly,
    required this.isLocked,
    required this.thumbList,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.allStickerPro,
    this.showLockIcon = false,
  });

  List<Sticker> stickers;
  String stickerType;
  ScrollController scrollController;
  bool isViewOnly = false;
  bool isLocked = false;
  bool showLockIcon = false;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
  List<ChatContent> chatContentList;
  Map<String, List<Sticker>> allStickerPro;

  @override
  State<StickerGrid> createState() => _StickerGridState();
}

class _StickerGridState extends State<StickerGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final Sticker sticker = widget.stickers[index];

        return buildStickerItem(
          context: context,
          sticker: sticker,
          isLocked: sticker.isPremium && widget.isLocked,
          isViewOnly: false,
          onSelected: () {
            Navigator.of(context).pop();

            setState(() {
              widget.recentsStickerList.removeWhere((s) => s.imagePath == sticker.imagePath);
              widget.recentsStickerList.insert(0, sticker);

              if (widget.recentsStickerList.length > 5) {
                widget.recentsStickerList.removeAt(5);
              }
              widget.chatContentList.insert(0, ChatContent(sticker: sticker));
            });
            FocusScope.of(context).unfocus();
          },
          onShowProDetail: () {
            stickerShopDetail(
              context: context,
              scrollController: widget.scrollController,
              stickerType: widget.stickerType,
              allStickerPro: widget.allStickerPro,
              thumbList: widget.thumbList,
              recentsStickerList: widget.recentsStickerList,
              chatContentList: widget.chatContentList,
            );
          },
          showLockIcon: widget.showLockIcon,
        );
      }, childCount: widget.stickers.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // 5 phần tử mổi dòng
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

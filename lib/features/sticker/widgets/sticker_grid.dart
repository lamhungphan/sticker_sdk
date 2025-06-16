import 'package:flutter/material.dart';
import 'package:sticker_app/core/utils/sticker_preview.dart';
import 'package:sticker_app/core/utils/thumb_update.dart';
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
  });

  List<Sticker> stickers;
  String stickerType;
  ScrollController scrollController;
  bool isViewOnly = false;
  bool isLocked = false;
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
        return GestureDetector(
          // Nhấn giữ để hiện preview
          onLongPress: () => showStickerPreview(context, sticker),
          onTap: () async {
            sticker.isPro
                ? await stickerShopDetail(
                  context: context,
                  scrollController: widget.scrollController,
                  stickerType: widget.stickerType,
                  allStickerPro: widget.allStickerPro,
                  thumbList: widget.thumbList,
                  recentsStickerList: widget.recentsStickerList,
                  chatContentList: widget.chatContentList,
                )
                : {
                  Navigator.of(context).pop(),

                  // Nếu Sticker đã có trong phần Recents, xóa Sticker
                  setState(() {
                    widget.recentsStickerList.removeWhere((Sticker s) => s.path == sticker.path);

                    // Thêm lại Sticker vào đầu danh sách
                    widget.recentsStickerList.insert(0, sticker);

                    // Chỉ hiển thị 5 Sticker cho rencent list
                    if (widget.recentsStickerList.length > 5) {
                      widget.recentsStickerList.removeAt(5);
                    }

                    // Thêm Sticker mới chọn vào chat
                    widget.chatContentList.insert(0, ChatContent(sticker: sticker));

                    updateThumbnailSticker(stickerThumb: widget.thumbList, stickerType: sticker.type);
                  }),

                  FocusScope.of(context).unfocus(),
                };
          },

          // Thả trạng thái giữ để tắt preview
          onLongPressEnd: (_) => hideStickerPreview(),
          child:
              // Nếu đó là Sticker pro và bị yêu cầu khóa
              sticker.isPro && widget.isLocked
                  // Thì trả về Sticker khóa
                  ? Stack(
                    children: [
                      Opacity(opacity: 0.5, child: Image.network(sticker.path)),
                      const Center(child: Icon(Icons.lock, color: Colors.red)),
                    ],
                  )
                  // Không thì Sticker bình thường
                  : Image.network(sticker.path),
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

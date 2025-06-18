import 'package:flutter/material.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_grid.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_show_type.dart';
import 'package:sticker_app/models/chat_content.dart';
import 'package:sticker_app/models/sticker.dart';

// ignore: must_be_immutable
class StickerFiltered extends StatefulWidget {
  StickerFiltered({
    super.key,
    required this.currentStickerType,
    required this.allStickerList,
    required this.scrollController,
    required this.modalSetState,
    required this.isRecentSelected,
    required this.thumbList,
    required this.recentsStickerList,
    required this.chatContentList,
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
  List<ChatContent> chatContentList;
  Map<String, List<Sticker>> allStickerPro;
  Function(String) onStickerTypeChanged;

  @override
  State<StickerFiltered> createState() => _StickerFilteredState();
}

class _StickerFilteredState extends State<StickerFiltered> {
  @override
  Widget build(BuildContext context) {
    final Map<String, List<Sticker>> filteredStickers =
        // Nếu thumb được chọn là Recents
        (widget.currentStickerType == 'Recents')
            // Thì lấy tất cả các loại Sticker
            ? Map<String, List<Sticker>>.fromEntries(widget.allStickerList.entries.take(5))
            // Còn không thì lấy tất cả Sticker của 1 loại Sticker
            : <String, List<Sticker>>{
              widget.currentStickerType: widget.allStickerList[widget.currentStickerType] ?? [],
            };

    return Expanded(
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers:
            filteredStickers.entries
                .expand((entry) {
                  // Lấy key là loại của Sticker
                  final String stickerType = entry.key;
                  // Lấy value là tất cả các Sticker
                  final List<Sticker> stickers =
                      (widget.currentStickerType == 'Recents') ? entry.value.take(5).toList() : entry.value;

                  return stickers.isNotEmpty
                      ? [
                        StickerShowType(
                          modalSetState: widget.modalSetState,
                          scrollController: widget.scrollController,
                          stickerType: stickerType,
                          stickerCount: entry.value.length,
                          showCount: false,
                          isViewOnly: widget.currentStickerType == 'Recents' ? false : true,
                          isRecentSelected: widget.isRecentSelected,
                          thumbList: widget.thumbList,
                          onStickerTypeChanged: (String newType) {
                            setState(() {
                              widget.currentStickerType = newType;
                              widget.isRecentSelected = newType == 'Recents';
                            });

                            // Để trả về widget cha 1 String
                            widget.onStickerTypeChanged(newType);
                          },
                        ),
                        StickerGrid(
                          stickers: stickers,
                          stickerType: stickerType,
                          scrollController: widget.scrollController,
                          isViewOnly: widget.currentStickerType == 'Recents' ? true : false,
                          isLocked: true,
                          thumbList: widget.thumbList,
                          recentsStickerList: widget.recentsStickerList,
                          chatContentList: widget.chatContentList,
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

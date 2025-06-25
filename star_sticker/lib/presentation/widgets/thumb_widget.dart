import 'package:flutter/material.dart';
import 'package:star_sticker/presentation/widgets/add_sticker_widget.dart';
import 'package:star_sticker/presentation/widgets/recent_sticker_widget.dart';
import 'package:star_sticker/presentation/widgets/shop_widget.dart';
import 'package:star_sticker/models/chat_content.dart';
import 'package:star_sticker/models/sticker.dart';

// ignore: must_be_immutable
class ThumbWidget extends StatefulWidget {
  ThumbWidget({
    super.key,
    required this.modalSetState,
    required this.scrollController,
    required this.allStickerPro,
    required this.isRecentSelected,
    required this.thumbList,
    required this.currentStickerType,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.onStickerTypeChanged,
  });

  StateSetter modalSetState;
  ScrollController scrollController;
  Map<String, List<Sticker>> allStickerPro;
  bool isRecentSelected;
  List<Sticker> thumbList;
  String currentStickerType;
  List<Sticker> recentsStickerList;
  List<ChatContent> chatContentList;
  Function(String) onStickerTypeChanged;

  @override
  State<ThumbWidget> createState() => _ThumbWidgetState();
}

class _ThumbWidgetState extends State<ThumbWidget> {
  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Tạo thumb cho shop Sticker
          ShopWidget(
            modalSetState: widget.modalSetState,
            scrollController: widget.scrollController,
            allStickerPro: widget.allStickerPro,
            isRecentSelected: widget.isRecentSelected,
            thumbList: widget.thumbList,
            recentsStickerList: widget.recentsStickerList,
            chatContentList: widget.chatContentList,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: screenSize * 0.04,
              right: screenSize * 0.02,
            ),
            child: const AddStickerWidget(),
          ),
          // Tạo thumbnail cho recents Sticker
          RecentStickerWidget(
            isRecentSelected: widget.isRecentSelected,
            modalSetState: widget.modalSetState,
            currentStickerType: widget.currentStickerType,
            scrollController: widget.scrollController,
            onStickerTypeChanged: (String newType) {
              widget.modalSetState(() {
                widget.onStickerTypeChanged(newType);
              });
            },
          ),

          // Tạo danh sách thumbnail cho các Sticker
          ..._stickerThumbList(widget.modalSetState, widget.scrollController),
        ],
      ),
    );
  }

  List<Widget> _stickerThumbList(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    // Lấy thumbnail hiện lên giao diện
    return List.generate(widget.thumbList.length, (int index) {
      Sticker thumbnail = widget.thumbList[index];
      // thumbnail.categoryId == currentStickerType ? isThumbnailSelected = true : false
      bool isThumbnailSelected = thumbnail.categoryId == widget.currentStickerType;

      final double screenSize = MediaQuery.of(context).size.width;

      return Padding(
        padding: EdgeInsets.only(right: screenSize * 0.01),
        child: GestureDetector(
          onTap: () {
            modalSetState(() {
              widget.onStickerTypeChanged(thumbnail.categoryId);
              scrollController.jumpTo(0);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(),
            width: 45,
            height: 45,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color:
                  isThumbnailSelected
                      ? Colors.black.withAlpha(32)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image(
              image: NetworkImage(thumbnail.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    });
  }
}

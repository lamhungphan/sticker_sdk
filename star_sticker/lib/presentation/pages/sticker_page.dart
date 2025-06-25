import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_sticker/presentation/provider/sticker_provider.dart';
import 'package:star_sticker/presentation/widgets/filtered_widget.dart';
import 'package:star_sticker/presentation/widgets/search_widget.dart';
import 'package:star_sticker/presentation/widgets/thumb_widget.dart';
import 'package:star_sticker/models/chat_content.dart';
import 'package:star_sticker/models/sticker.dart';

// ignore: must_be_immutable
class StickerPage extends StatefulWidget {
  StickerPage({
    super.key,
    required this.modalSetState,
    required this.scrollController,
    required this.chatContentList,
    required this.thumbList,
    required this.recentsStickerList,
    this.initialStickerType
  });

  StateSetter modalSetState;
  ScrollController scrollController;
  List<ChatContent> chatContentList;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
final String? initialStickerType;
  @override
  State<StickerPage> createState() => _StickerPageState();
}

class _StickerPageState extends State<StickerPage> {
  // Kiểm tra Recents có được chọn không
  bool isRecentSelected = false;
  // Lưu loại Sticker được chọn hiện tại
  String currentStickerType = '';
  // Lưu tất cả các Sticker pro
  Map<String, List<Sticker>> allStickerPro = {};
  // Lưu tất cả các Sticker
  Map<String, List<Sticker>> allStickerList = {};

  @override
  void initState() {
    super.initState();
    // Gọi API khi widget khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StickerProvider>(context, listen: false).loadAllStickers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    final provider = Provider.of<StickerProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    if (provider.thumb.isEmpty) {
      return const Center(child: Text('No thumb found'));
    }

    final hasData = provider.allSticker.isNotEmpty && provider.premiumSticker.isNotEmpty && provider.thumb.isNotEmpty;

    if (!hasData) {
      return const Center(child: Text('No sticker found'));
    }

    allStickerPro = provider.premiumSticker;

    allStickerList = provider.allSticker;

    // Cho màn hình mở đầu luôn là Recents
    if (currentStickerType.isEmpty && widget.thumbList.isNotEmpty) {
      currentStickerType = 'Recents';
      isRecentSelected = true;
    }

    // Đưa các Sticker trong recentsStickerList vào allStickerList
    allStickerList = {'Recents': widget.recentsStickerList, ...allStickerList};

    return Column(
      children: [
        ThumbWidget(
          modalSetState: widget.modalSetState,
          scrollController: widget.scrollController,
          allStickerPro: allStickerPro,
          isRecentSelected: isRecentSelected,
          thumbList: widget.thumbList,
          currentStickerType: currentStickerType,
          recentsStickerList: widget.recentsStickerList,
          chatContentList: widget.chatContentList,
          onStickerTypeChanged: (String newType) {
            widget.modalSetState(() {
              currentStickerType = newType;
              isRecentSelected = newType == 'Recents';
            });
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: screenSize * 0.02, bottom: screenSize * 0.01),
          child: SearchWidget(
            types: allStickerList.keys.toList(),
            onMatched: (String matchedType) {
              widget.modalSetState(() {
                currentStickerType = matchedType;
                isRecentSelected = matchedType == 'Recents';
              });
            },
            onEmpty: () {
              widget.modalSetState(() {
                currentStickerType = 'Recents';
                isRecentSelected = true;
              });
            },
          ),
        ),

        FilteredWidget(
          currentStickerType: currentStickerType,
          allStickerList: allStickerList,
          scrollController: widget.scrollController,
          modalSetState: widget.modalSetState,
          isRecentSelected: isRecentSelected,
          thumbList: widget.thumbList,
          recentsStickerList: widget.recentsStickerList,
          chatContentList: widget.chatContentList,
          allStickerPro: allStickerPro,
          onStickerTypeChanged: (String newType) {
            widget.modalSetState(() {
              currentStickerType = newType;
              isRecentSelected = newType == 'Recents';
            });
          },
        ),
      ],
    );
  }
}

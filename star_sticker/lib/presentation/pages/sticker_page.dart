import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_sticker/presentation/provider/sticker_provider.dart';
import 'package:star_sticker/presentation/widgets/filtered_widget.dart';
import 'package:star_sticker/presentation/widgets/search_widget.dart';
import 'package:star_sticker/presentation/widgets/thumb_widget.dart';
import 'package:star_sticker/models/sticker.dart';

// ignore: must_be_immutable
class StickerPage extends StatefulWidget {
  StickerPage({
    super.key,
    this.onStickerSelected,
  });

  final Function(String stickerUrl)? onStickerSelected;

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
  // Lưu các Sticker vừa dùng

  // Lưu các thumb
  List<Sticker> thumbList = [];
  // ScrollController cho widgets
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<StickerProvider>(context, listen: false).loadAllStickers();
    // });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    final provider = Provider.of<StickerProvider>(context);

    // if (provider.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    // Nếu chưa có data thì hiển thị loading (trường hợp init chưa xong)
    if (!provider.hasData || provider.thumb.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    allStickerPro = provider.premiumSticker;
    allStickerList = provider.allSticker;
    thumbList = provider.thumb;

    // Cho màn hình mở đầu luôn là Recents
    if (currentStickerType.isEmpty && thumbList.isNotEmpty) {
      currentStickerType = 'Recents';
      isRecentSelected = true;
    }

    // Đưa các Sticker trong recentsStickerList vào allStickerList
    allStickerList = {
      'Recents': provider.recentsStickerList,
      ...allStickerList
    };

    return Column(
      children: [
        ThumbWidget(
          modalSetState: setState,
          scrollController: scrollController,
          allStickerPro: allStickerPro,
          isRecentSelected: isRecentSelected,
          thumbList: thumbList,
          currentStickerType: currentStickerType,
          recentsStickerList: provider.recentsStickerList,
          onStickerTypeChanged: (String newType) {
            setState(() {
              currentStickerType = newType;
              isRecentSelected = newType == 'Recents';
            });
          },
          onStickerSelected: widget.onStickerSelected,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: screenSize * 0.02, bottom: screenSize * 0.01),
          child: SearchWidget(
            types: allStickerList.keys.toList(),
            onMatched: (String matchedType) {
              setState(() {
                currentStickerType = matchedType;
                isRecentSelected = matchedType == 'Recents';
              });
            },
            onEmpty: () {
              setState(() {
                currentStickerType = 'Recents';
                isRecentSelected = true;
              });
            },
          ),
        ),
        FilteredWidget(
          currentStickerType: currentStickerType,
          allStickerList: allStickerList,
          scrollController: scrollController,
          modalSetState: setState,
          isRecentSelected: isRecentSelected,
          thumbList: thumbList,
          recentsStickerList: provider.recentsStickerList,
          allStickerPro: allStickerPro,
          onStickerTypeChanged: (String newType) {
            setState(() {
              currentStickerType = newType;
              isRecentSelected = newType == 'Recents';
            });
          },
          onStickerSelected: (sticker) {
            widget.onStickerSelected?.call(sticker.imagePath);
            provider.recentsStickerList.insert(0, sticker);
          },
        ),
      ],
    );
  }
}

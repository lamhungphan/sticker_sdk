import 'package:flutter/material.dart';
import 'package:star_sticker/models/category.dart';
import 'package:star_sticker/utils/item_builder.dart';
import 'package:star_sticker/presentation/widgets/shop_detail_widget.dart';
import 'package:star_sticker/models/sticker.dart';

// ignore: must_be_immutable
class GridWidget extends StatefulWidget {
  GridWidget({
    super.key,
    required this.stickers,
    required this.category,
    required this.scrollController,
    required this.isViewOnly,
    required this.isLocked,
    required this.thumbList,
    required this.recentsStickerList,
    required this.allStickerPro,
    this.showLockIcon = false,
    this.onStickerSelected,
  });

  List<Sticker> stickers;
  Category category;
  ScrollController scrollController;
  bool isViewOnly = false;
  bool isLocked = false;
  bool showLockIcon = false;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
  Map<String, List<Sticker>> allStickerPro;
  Function(Sticker sticker)? onStickerSelected;

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final Sticker sticker = widget.stickers[index];

        return itemBuilder(
          context: context,
          sticker: sticker,
          isLocked: sticker.isPremium && widget.isLocked,
          isViewOnly: false,
          onSelected: () {
            if (widget.onStickerSelected != null) {
              widget.onStickerSelected!(sticker);
            }

            Navigator.of(context).pop();

            // setState(() {
            //   widget.recentsStickerList
            //       .removeWhere((s) => s.imagePath == sticker.imagePath);
            //   widget.recentsStickerList.insert(0, sticker);

            //   if (widget.recentsStickerList.length > 5) {
            //     widget.recentsStickerList.removeAt(5);
            //   }
            // });
            FocusScope.of(context).unfocus();
          },
          onShowProDetail: () {
            shopDetailWidget(
              context: context,
              scrollController: widget.scrollController,
              category: widget.category,
              allStickerPro: widget.allStickerPro,
              thumbList: widget.thumbList,
              recentsStickerList: widget.recentsStickerList,
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

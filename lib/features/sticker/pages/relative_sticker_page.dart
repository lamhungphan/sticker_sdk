import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticker_app/core/utils/item_builder.dart';
import 'package:sticker_app/features/sticker/provider/sticker_provider.dart';
import 'package:sticker_app/features/sticker/widgets/shop_detail_widget.dart';
import 'package:sticker_app/models/category.dart';
import 'package:sticker_app/models/sticker.dart';

class RelativeStickerPage extends StatelessWidget {
  final Category category;
  final void Function(Sticker sticker) onStickerSelected;

  const RelativeStickerPage({super.key, required this.category, required this.onStickerSelected});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StickerProvider>(context);
    final stickerList = provider.allSticker[category.name] ?? [];

    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.error != null) return Center(child: Text('Lỗi: ${provider.error}'));
    if (stickerList.isEmpty) return const Center(child: Text('Không tìm thấy sticker'));

    final screenSize = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenSize * 0.04),
          child: Text(category.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenSize * 0.04),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: stickerList.length,
            itemBuilder: (context, index) {
              final sticker = stickerList[index];
              final isPremium = provider.isStickerPremium(category.name, sticker);

              return itemBuilder(
                context: context,
                sticker: sticker,
                isLocked: isPremium,
                isViewOnly: false, 
                showLockIcon: sticker.isPremium,
                onSelected: () => onStickerSelected(sticker),
                onShowProDetail:
                    () => shopDetailWidget(
                      context: context,
                      scrollController: ScrollController(),
                      stickerType: category.name  ,
                      allStickerPro: provider.premiumSticker,
                      thumbList: provider.thumb,
                      recentsStickerList: [],
                      chatContentList: [],
                    ),
              );
            },
          ),
        ),
      ],
    );
  }
}

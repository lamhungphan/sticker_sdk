import 'package:flutter/material.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_grid.dart';
import 'package:sticker_app/models/chat_content.dart';
import 'package:sticker_app/models/sticker.dart';

Future stickerShopDetail({
  required BuildContext context,
  required ScrollController scrollController,
  required String stickerType,
  required Map<String, List<Sticker>> allStickerPro,
  required List<Sticker> thumbList,
  required List<Sticker> recentsStickerList,
  required List<ChatContent> chatContentList,
}) {
  final double screenSize = MediaQuery.of(context).size.height;

  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      side: BorderSide(width: 0.5),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext modalContext) {
      return StatefulBuilder(
        builder: (
          BuildContext statefulBuilderContext,
          StateSetter modalSetState,
        ) {
          return DraggableScrollableSheet(
            initialChildSize: 0.4,
            maxChildSize: 0.7,
            minChildSize: 0.2,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: EdgeInsets.only(
                  top: screenSize * 0.01,
                  left: screenSize * 0.01,
                  right: screenSize * 0.01,
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenSize * 0.005),
                        child: Center(
                          child: Text(
                            '$stickerType Premium',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(screenSize * 0.01),
                      sliver: StickerGrid(
                        stickers: allStickerPro[stickerType] ?? [],
                        stickerType: stickerType,
                        scrollController: scrollController,
                        isViewOnly: true,
                        isLocked: false,
                        thumbList: thumbList,
                        recentsStickerList: recentsStickerList,
                        chatContentList: chatContentList,
                        allStickerPro: allStickerPro,
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: screenSize * 0.01,
                            bottom: screenSize * 0.02,
                          ),
                          child: FractionallySizedBox(
                            // Cho phép nút bấm kéo dài 100% màn hình
                            widthFactor: 1,
                            child: MaterialButton(
                              padding: EdgeInsets.all(screenSize * 0.015),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.blue,
                              onPressed: () {
                                // Biến các sticker này isPro = false
                                // và đưa vào nhóm sticker đó
                              },
                              child: const Text(
                                'Add to Library',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

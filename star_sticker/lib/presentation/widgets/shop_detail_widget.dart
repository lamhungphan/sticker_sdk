import 'package:flutter/material.dart';
import 'package:star_sticker/presentation/pages/checkout_page.dart';
import 'package:star_sticker/presentation/widgets/grid_widget.dart';
import 'package:star_sticker/models/chat_content.dart';
import 'package:star_sticker/models/sticker.dart';
import 'package:star_sticker/sticker.dart';

Future shopDetailWidget({
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
                      sliver: GridWidget(
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => 
                                      const CheckoutPage(key: Key('checkout')),
                                  ),
                                );
                              },
                              child: const Text(
                                'Checkout',
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

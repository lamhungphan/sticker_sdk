import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticker_app/features/sticker/provider/sticker_provider.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_type_viewer.dart';
import 'package:sticker_app/models/chat_content.dart';

// ignore: must_be_immutable
class ChatList extends StatelessWidget {
  ChatList({
    super.key,
    required this.content,
    required this.onStickerSelected,
  });

  final ChatContent content;
  final void Function(ChatContent newContent) onStickerSelected;

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomRight,
      child: content.sticker != null
          ? SizedBox(
              width: screenSize * 0.25,
              height: screenSize * 0.25,
              child: GestureDetector(
                onTap: () async {
                  final stickerType = content.sticker?.type;

                  if (stickerType != null && stickerType.isNotEmpty) {
                    final provider = Provider.of<StickerProvider>(context, listen: false);

                    if (provider.allSticker.isEmpty) {
                      await provider.loadAllStickers();
                    }

                    if (!context.mounted) return;

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: StickerTypeViewer(
                            type: stickerType,
                            onStickerSelected: (sticker) {
                              final newMessage = ChatContent(
                                sticker: sticker,
                              );
                              onStickerSelected(newMessage);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
                child: Image.network(content.sticker!.path),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(right: screenSize * 0.02, top: screenSize * 0.02),
              child: Container(
                constraints: BoxConstraints(maxWidth: screenSize * 0.5),
                padding: EdgeInsets.symmetric(
                  vertical: screenSize * 0.02,
                  horizontal: screenSize * 0.04,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(content.text!, style: const TextStyle(fontSize: 16)),
              ),
            ),
    );
  }
}

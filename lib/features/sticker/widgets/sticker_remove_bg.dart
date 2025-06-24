import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sticker_app/models/sticker.dart';
import 'package:sticker_app/services/remove_bg_api.dart';
import 'package:sticker_app/services/sticker_api.dart';

void imageOverlay({
  required BuildContext context,
  required File imageFile,
  required void Function(Sticker sticker) onStickerSelected,
}) {
  bool isLoading = false;
  bool isCutDone = false;
  File? displayedImage = imageFile;
  final double screenSize = MediaQuery.of(context).size.width;

  late void Function(void Function()) setState;

  _imgOverlay = OverlayEntry(
    builder: (BuildContext overlayEntryContext) {
      return StatefulBuilder(
        builder: (context, setStateOverlay) {
          setState = setStateOverlay;

          return Stack(
            children: [
              Container(color: Colors.black.withOpacity(0.7)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Padding(
                              padding: const EdgeInsets.all(16),
                              child:
                                  displayedImage != null
                                      ? Image.file(displayedImage!, fit: BoxFit.contain)
                                      : const Center(child: Text('Không có ảnh')),
                            ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          hideImage();
                        },
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (displayedImage == null) return;

                            if (!isCutDone) {
                              setState(() => isLoading = true);
                              final File? removedBg = await RemoveBgService.removeBackground(displayedImage!);
                              setState(() => isLoading = false);

                              if (removedBg != null) {
                                setState(() {
                                  displayedImage = removedBg;
                                  isCutDone = true;
                                });
                                debugPrint('Hình ảnh cắt thành công: ${removedBg.path}');
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(const SnackBar(content: Text('Không thể xoá nền ảnh')));
                                }
                                return;
                              }
                            } else {
                              final newSticker = Sticker(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                imagePath: displayedImage!.path,
                                categoryId: 'Custom',
                                isPremium: false,
                                status: 'active',
                                usedCount: 0,
                                tags: [],
                              );

                              setState(() => isLoading = true);
                              final success = await StickerApi.uploadSticker(newSticker, displayedImage!);
                              setState(() => isLoading = false);

                              if (success) {
                                hideImage();
                                onStickerSelected(newSticker);
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(const SnackBar(content: Text('Không thể lưu sticker')));
                                }
                              }
                            }
                          },
                          icon: Icon(isCutDone ? Icons.check : Icons.cut),
                          label: Text(isCutDone ? "Lưu & Dùng sticker" : "Xoá nền ảnh"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: screenSize * 0.035),
                            backgroundColor: isCutDone ? Colors.green : Colors.grey,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );

  Overlay.of(context).insert(_imgOverlay!);
}

OverlayEntry? _imgOverlay;

void hideImage() {
  _imgOverlay?.remove();
  _imgOverlay = null;
}

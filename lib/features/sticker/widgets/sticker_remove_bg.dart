import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sticker_app/models/sticker.dart';
import 'package:sticker_app/services/remove_bg_api.dart';

OverlayEntry? _imgOverlay;

void imageOverlay({
  required BuildContext context,
  required File imageFile,
  required void Function(Sticker sticker) onStickerSelected,
}) {
  final double screenSize = MediaQuery.of(context).size.width;

  late void Function(void Function()) setState;

  bool isLoading = false;
  bool isCutDone = false;

  File? displayedImage = imageFile;

  _imgOverlay = OverlayEntry(
    builder: (BuildContext overlayEntryContext) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setStateOverlay) {
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
                            : Padding(padding: const EdgeInsets.all(16), child: Image.file(displayedImage!)),
                  ),
                  Row(
                    children: [
                      IconButton(onPressed: hideImage, icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (isCutDone) {
                              // Tạo sticker object từ file đã xử lý
                              final newSticker = Sticker(
                                id: DateTime.now().millisecondsSinceEpoch.toString(), // ID tạm thời
                                path: displayedImage!.path,
                                type: 'Custom',
                                isPro: false,
                              );

                              // Ẩn overlay trước khi gọi callback
                              hideImage();

                              // Gọi callback để sử dụng sticker
                              onStickerSelected(newSticker);
                            } else {
                              // Tiến hành cắt nền
                              setState(() => isLoading = true);

                              final File? removedBg = await RemoveBgService.removeBackground(imageFile);

                              if (removedBg != null) {
                                setState(() {
                                  isLoading = false;
                                  isCutDone = true;
                                  displayedImage = removedBg;
                                  print('Hinh anh cat thanh cong '+displayedImage!.path);
                                });
                                
                              } else {
                                setState(() => isLoading = false);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(const SnackBar(content: Text('Không thể xoá nền ảnh')));
                                }

                                hideImage();
                              }
                            }
                          },
                          icon: Icon(isCutDone ? Icons.check : Icons.cut),
                          label: Text(isCutDone ? "Dùng sticker này" : "Xoá nền ảnh"),
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

void hideImage() {
  _imgOverlay?.remove();
  _imgOverlay = null;
}

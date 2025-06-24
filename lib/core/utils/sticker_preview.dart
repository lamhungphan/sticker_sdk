import 'package:flutter/material.dart';
import 'package:sticker_app/models/sticker.dart';

OverlayEntry? _previewOverlay;

void showStickerPreview(BuildContext context, Sticker sticker) {
  final double screenSize = MediaQuery.of(context).size.width;

  _previewOverlay = OverlayEntry(
    builder: (BuildContext overlayEntryContext) {
      // Chiếm toàn bộ màn hình với Positioned.fill
      return Positioned.fill(
        child: Container(
          // 128 là mờ 50%
          color: Colors.black.withAlpha(128),
          alignment: Alignment.center,
          child: Image.network(
            sticker.imagePath,
            width: screenSize * 0.7,
            height: screenSize * 0.7,
          ),
        ),
      );
    },
  );
  // Lấy Overlay hiện tại từ context. Gọi '.insert()' để chèn overlay vào giao diện
  Overlay.of(context).insert(_previewOverlay!);
}

void hideStickerPreview() {
  // Gỡ overlay ra khỏi giao diện
  _previewOverlay?.remove();
  // Cho về null để tránh lỗi khi tạo overlay mới
  _previewOverlay = null;
}

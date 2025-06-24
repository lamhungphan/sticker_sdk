import 'package:flutter/material.dart';
import 'package:sticker_app/models/sticker.dart';

OverlayEntry? _previewOverlay;

void showPreview(BuildContext context, Sticker sticker, {required void Function(Sticker) onStickerSelected}) {
  final double screenSize = MediaQuery.of(context).size.width;

  _previewOverlay = OverlayEntry(
    builder: (BuildContext overlayEntryContext) {
      return GestureDetector(
        onTap: hidePreview, // Bấm vùng ngoài
        child: Material(
          color: Colors.black.withAlpha(128),
          child: Center(
            child: GestureDetector(
              onTap: () {
                hidePreview();
                onStickerSelected(sticker);
              },
              child: Image.network(sticker.imagePath, width: screenSize * 0.7, height: screenSize * 0.7),
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(_previewOverlay!);
}

void hidePreview() {
  // Gỡ overlay ra khỏi giao diện
  _previewOverlay?.remove();
  // Cho về null để tránh lỗi khi tạo overlay mới
  _previewOverlay = null;
}

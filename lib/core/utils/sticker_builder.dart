import 'package:flutter/material.dart';
import 'package:sticker_app/core/utils/sticker_preview.dart';
import 'package:sticker_app/models/sticker.dart';

Widget buildStickerItem({
  required BuildContext context,
  required Sticker sticker,
  required bool isLocked,
  required bool isViewOnly,
  required VoidCallback onSelected,
  required VoidCallback onShowProDetail,
}) {
  return GestureDetector(
    onTap: () {
      handleStickerTap(
        context: context,
        sticker: sticker,
        isLocked: isLocked,
        isViewOnly: isViewOnly,
        onSelected: onSelected,
        onShowProDetail: onShowProDetail,
      );
    },
    onLongPress: () => showStickerPreview(context, sticker),
    onLongPressEnd: (_) => hideStickerPreview(),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Image.network(sticker.path),
        ),
        if (isLocked)
          const Icon(Icons.lock, color: Colors.red),
      ],
    ),
  );
}

void handleStickerTap({
  required BuildContext context,
  required Sticker sticker,
  required bool isLocked,
  required bool isViewOnly,
  required VoidCallback onSelected,
  required VoidCallback onShowProDetail,
}) {
  if (sticker.isPro) {
    if (isLocked) {
      onShowProDetail();
    }
    return;
  }

  // Sticker thường
  if (!isViewOnly) {
    onSelected();
  }
}


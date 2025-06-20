import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_remove_bg.dart';
import 'package:sticker_app/models/sticker.dart';

class StickerAdd extends StatelessWidget {
  const StickerAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile == null) {
          return;
        }

        final File imageFile = File(pickedFile.path);
        imageOverlay(
          context: context,
          imageFile: imageFile,
          onStickerSelected: (Sticker sticker) {
            // TODO: Handle the selected sticker
          },
        );
      },
      child: const Icon(Icons.add_reaction_outlined, size: 25),
    );
  }
}

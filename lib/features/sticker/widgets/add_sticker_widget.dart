import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sticker_app/features/sticker/pages/edit_sticker_page.dart';

class AddStickerWidget extends StatelessWidget {
  const AddStickerWidget({super.key});

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
       
        EditStickerPage.open(context, imageFile);
      },
      child: const Icon(Icons.add_reaction_outlined, size: 25),
    );
  }
}

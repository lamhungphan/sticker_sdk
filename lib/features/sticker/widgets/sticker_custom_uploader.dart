// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sticker_app/features/sticker/widgets/sticker_remove_bg.dart';
// import 'package:sticker_app/models/sticker.dart';

// Future<void> customStickerUploader({
//   required BuildContext context,
//   // required Null Function(Sticker sticker) onStickerSelected,
// }) async {
//   FocusScope.of(context).unfocus();

//   // Sử dụng hệ thống picker mặc định
//   final ImagePicker picker = ImagePicker();
//   final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedFile == null) {
//     return;
//   }

//   final File imageFile = File(pickedFile.path);
//   print(imageFile);
//   // Gọi overlay xử lý ảnh
//   imageOverlay(context: context, imageFile: imageFile);
// }

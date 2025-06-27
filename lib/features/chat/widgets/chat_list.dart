// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:star_sticker/models/category.dart';
// import 'package:star_sticker/models/sticker.dart';
// import 'package:star_sticker/presentation/provider/sticker_provider.dart';
// import 'package:star_sticker/presentation/pages/relative_sticker_page.dart';
import 'package:sticker_app/models/chat_content.dart';

// ignore: must_be_immutable
class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
    required this.content,
    required this.onStickerSelected,
  });

  final ChatContent content;
  final void Function(ChatContent newContent) onStickerSelected;

  // Widget _buildStickerImage(Sticker sticker) {
  //   final isLocal = sticker.imagePath.startsWith('/') || sticker.imagePath.startsWith('file://');
  //   return isLocal
  //       ? Image.file(File(sticker.imagePath), fit: BoxFit.contain)
  //       : Image.network(sticker.imagePath, fit: BoxFit.contain);
  // }

  @override
  Widget build(BuildContext context) {
    // final double screenSize = MediaQuery.of(context).size.width;

    // Hiển thị sticker nếu có stickerUrl
    if (content.stickerUrl != null && content.stickerUrl!.isNotEmpty) {
      final double screenSize = MediaQuery.of(context).size.width;
      return Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          width: screenSize * 0.25,
          height: screenSize * 0.25,
          child: Image.network(
            content.stickerUrl!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.red);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      );
    }

    // Hiển thị text nếu có
    if (content.text != null && content.text!.isNotEmpty) {
      final double screenSize = MediaQuery.of(context).size.width;
      return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(
            right: screenSize * 0.02,
            top: screenSize * 0.02,
          ),
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

    // Fallback nếu không có gì
    return const SizedBox.shrink();

    // return Text(content.text!);

    // Align(
    //   alignment: Alignment.bottomRight,
    //   child:
    //       content.sticker != null
    //           ? SizedBox(
    //             width: screenSize * 0.25,
    //             height: screenSize * 0.25,
    //             child: GestureDetector(
    //               onTap: () async {
    //                 final category = content.sticker?.categoryId;

    //                 if (category != null && category.isNotEmpty) {
    //                   // final provider = Provider.of<StickerProvider>(context, listen: false);

    //                   // if (provider.allSticker.isEmpty) {
    //                   //   await provider.loadAllStickers();
    //                   // }

    //                   if (!context.mounted) return;

    //                   showModalBottomSheet(
    //                     context: context,
    //                     isScrollControlled: true,
    //                     builder: (ctx) {
    //                       return const SizedBox.shrink();
    //                       // return SizedBox(
    //                       //   height: MediaQuery.of(context).size.height * 0.6,
    //                       //   child: RelativeStickerPage(
    //                       //     category: Category(id: category, name: category, imagePath: '', price: 0),
    //                       //     onStickerSelected: (sticker) {
    //                       //       final newMessage = ChatContent(sticker: sticker as Sticker?);
    //                       //       onStickerSelected(newMessage);
    //                       //       Navigator.pop(context);
    //                       //     },
    //                       //   ),
    //                       // );
    //                     },
    //                   );
    //                 }
    //               },
    //               // child: _buildStickerImage(content.sticker!),
    //             ),
    //           )
    //           : Padding(
    //             padding: EdgeInsets.only(right: screenSize * 0.02, top: screenSize * 0.02),
    //             child: Container(
    //               constraints: BoxConstraints(maxWidth: screenSize * 0.5),
    //               padding: EdgeInsets.symmetric(vertical: screenSize * 0.02, horizontal: screenSize * 0.04),
    //               decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(16)),
    //               child: Text(content.text!, style: const TextStyle(fontSize: 16)),
    //             ),
    //           ),
    // );
  }
}

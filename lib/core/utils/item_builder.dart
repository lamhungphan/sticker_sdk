// import 'package:flutter/material.dart';
// import 'package:star_sticker/models/sticker.dart';

// Widget itemBuilder({
//   required BuildContext context,
//   required Sticker sticker,
//   required bool isLocked,
//   required bool isViewOnly,
//   required VoidCallback onSelected,
//   required VoidCallback onShowProDetail,
//   bool showLockIcon = true,
// }) {
//   return GestureDetector(
//     onTap: () {
//       handleStickerTap(
//         context: context,
//         sticker: sticker,
//         isLocked: isLocked,
//         isViewOnly: isViewOnly,
//         onSelected: onSelected,
//         onShowProDetail: onShowProDetail,
//       );
//     },
//     onLongPress: () {
//       showPreviewWithOptions(context, sticker, onSelected);
//     },

//     child: Stack(
//       alignment: Alignment.center,
//       children: [
//         Image.network(sticker.imagePath),
//         if (isLocked && showLockIcon) const Icon(Icons.lock, color: Colors.red),
//       ],
//     ),
//   );
// }

// void showPreviewWithOptions(BuildContext context, Sticker sticker, VoidCallback onSelected) {
//   showDialog(
//     context: context,
//     barrierColor: Colors.black.withOpacity(0.5),
//     builder: (_) {
//       final screenSize = MediaQuery.of(context).size.width;

//       return GestureDetector(
//         onTap: () => Navigator.of(context).pop(),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Stack(
//             alignment: Alignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   onSelected();
//                 },
//                 child: Image.network(sticker.imagePath, width: screenSize * 0.6, height: screenSize * 0.6),
//               ),

//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ListTile(
//                         leading: const Icon(Icons.send),
//                         title: const Text('Gửi sticker'),
//                         onTap: () {
//                           Navigator.pop(context);
//                           onSelected();
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.favorite_border),
//                         title: const Text('Yêu thích'),
//                         onTap: () {
//                           Navigator.pop(context);
//                           ScaffoldMessenger.of(
//                             context,
//                           ).showSnackBar(const SnackBar(content: Text('Đã thêm vào yêu thích')));
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// void handleStickerTap({
//   required BuildContext context,
//   required Sticker sticker,
//   required bool isLocked,
//   required bool isViewOnly,
//   required VoidCallback onSelected,
//   required VoidCallback onShowProDetail,
// }) {
//   if (sticker.isPremium) {
//     if (isLocked) {
//       onShowProDetail();
//     }
//     return;
//   }

//   // Sticker thường
//   if (!isViewOnly) {
//     onSelected();
//   }
// }

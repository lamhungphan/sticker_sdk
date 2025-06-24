import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sticker_app/models/sticker.dart';
import 'package:sticker_app/services/remove_bg_api.dart';

class EditStickerPage extends StatefulWidget {
  final File imageFile;

  const EditStickerPage({super.key, required this.imageFile});

  @override
  State<EditStickerPage> createState() => _EditStickerPageState();

  // Hàm mở trang và nhận lại kết quả
  static Future<Sticker?> open(BuildContext context, File imageFile) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditStickerPage(imageFile: imageFile)),
    );
  }
}

class _EditStickerPageState extends State<EditStickerPage> {
  bool isLoading = false;
  bool isCutDone = false;
  late File displayedImage;

  @override
  void initState() {
    super.initState();
    displayedImage = widget.imageFile;
  }

  Future<bool> _onWillPop() async {
    if (isCutDone) return true;
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn thoát?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Thoát')),
        ],
      ),
    );
    return shouldLeave ?? false;
  }

  Future<void> _handleAction() async {
    if (isCutDone) {
      final newSticker = Sticker(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: displayedImage.path,
        categoryId: 'Custom',
        isPremium: false,
        status: 'active',
        usedCount: 0,
        tags: [],
      );
      Navigator.pop(context, newSticker);
    } else {
      setState(() => isLoading = true);
      final File? removedBg = await RemoveBgService.removeBackground(displayedImage);
      setState(() => isLoading = false);

      if (removedBg != null) {
        setState(() {
          displayedImage = removedBg;
          isCutDone = true;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể xoá nền ảnh')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: BackButton(color: Colors.white),
          title: const Text('Chỉnh sửa sticker', style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.file(displayedImage, fit: BoxFit.contain),
                    ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _handleAction,
                  icon: Icon(isCutDone ? Icons.check : Icons.cut),
                  label: Text(isCutDone ? 'Dùng sticker này' : 'Xoá nền ảnh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCutDone ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: screenSize * 0.035),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

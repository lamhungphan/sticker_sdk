import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticker_app/features/sticker/provider/sticker_provider.dart';
import 'package:sticker_app/models/sticker.dart';

class StickerTypeViewer extends StatelessWidget {
  final String type;
  final void Function(Sticker sticker) onStickerSelected;

  const StickerTypeViewer({super.key, required this.type, required this.onStickerSelected});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StickerProvider>(context);
    final allStickerList = provider.allSticker;
    final stickerList = allStickerList[type] ?? [];

    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.error != null) return Center(child: Text('Lỗi: ${provider.error}'));
    if (stickerList.isEmpty) return const Center(child: Text('Không tìm thấy sticker'));

    final screenSize = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenSize * 0.04),
          child: Text(type, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenSize * 0.04),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: stickerList.length,
            itemBuilder: (context, index) {
              final sticker = stickerList[index];
              return GestureDetector(
                onTap: () {
                  onStickerSelected(sticker);
                },
                child: Image.network(sticker.path),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticker_app/features/sticker/provider/photo_provider.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_remove_bg.dart';
import 'package:sticker_app/models/sticker.dart';

void customStickerUploader({required BuildContext context, required Null Function(Sticker sticker) onStickerSelected}) {
  FocusScope.of(context).unfocus();

  final double screenSize = MediaQuery.of(context).size.width;

  showModalBottomSheet(
    barrierColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      side: BorderSide(width: 0.5),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext modalContext) {
      // Gọi tại modal luôn vì Không có sự tái tạo lại widget cha
      // Provider chỉ cần được khởi tạo một lần khi mở modal
      return ChangeNotifierProvider(
        create: (_) {
          final provider = PhotoProvider();
          // Bắt đầu load khi mở modal
          provider.fetchMedia();

          return provider;
        },
        builder: (context, _) {
          return Consumer<PhotoProvider>(
            builder: (context, photoProvider, _) {
              if (photoProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final images = photoProvider.assets;

              if (images.isEmpty) {
                return const Center(child: Text('Không có hình ảnh nào'));
              }

              return DraggableScrollableSheet(
                initialChildSize: 0.85,
                maxChildSize: 0.85,
                expand: false,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: screenSize * 0.02),
                        child: const Text('All Photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenSize * 0.02),
                        child: const Text('Create a sticker from a photo'),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                          ),
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index) {
                            final file = photoProvider.getFile(index);

                            if (file == null) {
                              // Load file tại vị trí index
                              photoProvider.loadFileForIndex(index);

                              return const Center(child: CircularProgressIndicator());
                            }

                            return GestureDetector(
                              onTap: () async {
                                imageOverlay(
                                  context: context,
                                  imageFile: file,
                                  onStickerSelected: (sticker) {
                                    
                                  },
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  // Cho nền các hình là màu trắng
                                  // Nếu là nền trong suốt
                                  color: Colors.white,
                                ),
                                child: Image.file(file, fit: BoxFit.cover),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

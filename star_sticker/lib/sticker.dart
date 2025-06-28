import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_sticker/presentation/provider/category_provider.dart';
import 'package:star_sticker/presentation/provider/sticker_provider.dart';
import 'package:star_sticker/presentation/pages/sticker_page.dart';

class Sticker {
  static Sticker? _instance;
  static Sticker get instance => _instance ??= Sticker._();
  Sticker._();

  // Global providers để tái sử dụng
  static StickerProvider? _stickerProvider;
  static CategoryProvider? _categoryProvider;

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  // Khởi tạo providers và preload data cho sticker SDK
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Khởi tạo providers
      _stickerProvider = StickerProvider();
      _categoryProvider = CategoryProvider();

      // Preload tất cả dữ liệu sticker
      await _stickerProvider!.loadAllStickers();

      _isInitialized = true;
      debugPrint('Sticker SDK initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Sticker SDK: $e');
      rethrow;
    }
  }

  // Hiển thị bottom sheet với sticker page
  static Future<void> show(
    BuildContext context, {
    Function(String stickerUrl)? onStickerSelected,
  }) async {
    // Kiểm tra đã init chưa
    if (!_isInitialized) {
      debugPrint('Sticker SDK not initialized. Call Sticker.init() first.');
      return;
    }

    // Tránh tự động mở bàn phím
    FocusScope.of(context).unfocus();

    await showModalBottomSheet(
      // Không làm mờ đằng sau modal
      barrierColor: Colors.transparent,
      // Bo tròn góc
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        // Độ dày viền
        side: BorderSide(width: 0.5),
      ),
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _stickerProvider!),
            ChangeNotifierProvider.value(value: _categoryProvider!),
          ],
          child: Padding(
            padding: EdgeInsets.only(
              // Trả về chiều cao của phần bị che bởi bàn phím
              bottom: MediaQuery.of(modalContext).viewInsets.bottom,
            ),
            child: StatefulBuilder(
              builder: (
                BuildContext statefulBuilderContext,
                StateSetter modalSetState,
              ) {
                return DraggableScrollableSheet(
                  // Khi mở cố định tại 40% màn hình
                  initialChildSize: 0.4,
                  // Kéo lên tối đa 80%
                  maxChildSize: 0.8,
                  // Kéo xuống tối đa 20%
                  minChildSize: 0.2,
                  expand: false,
                  builder: (
                    BuildContext context,
                    ScrollController scrollController,
                  ) {
                    final double screenSize = MediaQuery.of(context).size.width;
                    return Padding(
                      padding: EdgeInsets.only(
                          left: screenSize * 0.03, right: screenSize * 0.03),
                      child: StickerPage(
                        onStickerSelected: onStickerSelected,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

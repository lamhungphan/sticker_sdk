import 'package:sticker_app/models/sticker.dart';

void updateThumbnail({
  required List<Sticker> stickerThumb,
  required String stickerType,
}) {
  // Tìm thumb đó trên thanh thumb bar
  final Sticker thumb = stickerThumb.firstWhere(
    (Sticker sticker) => sticker.categoryId == stickerType,
  );
  // Nếu đã có, xóa thumbnail
  stickerThumb.removeWhere((Sticker s) => s.categoryId == stickerType);
  // Thêm lại vào đầu danh sách
  stickerThumb.insert(0, thumb);
}

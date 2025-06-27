import 'package:provider/provider.dart';
import 'package:star_sticker/models/sticker.dart';
import 'package:star_sticker/presentation/provider/category_provider.dart';
import 'package:star_sticker/presentation/provider/sticker_provider.dart';
import 'package:star_sticker/services/sticker_api.dart';

void initSticker() async {
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => StickerProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ],
  );
}

List<Sticker> thumbList = [];
List<Sticker> recentsStickerList = [];

Future<void> feachApi() async {
  thumbList = await StickerApi.fetchThumb();
}

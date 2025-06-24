import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sticker_app/features/friend/pages/friend_page.dart';
import 'package:sticker_app/features/friend/provider/user_provider.dart';
import 'package:sticker_app/features/sticker/provider/sticker_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e, stackTrace) {
    print("Lỗi load .env: $e");
    print("Chi tiết lỗi: $stackTrace");
    // Bạn có thể fallback URL mặc định ở đây nếu muốn
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => StickerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: FriendPage());
  }
}

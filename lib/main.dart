import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:star_sticker/sticker.dart';
// import 'package:provider/provider.dart';
// import 'package:sticker_app/features/chat/widgets/chat_list.dart';
// import 'package:sticker_app/features/friend/pages/friend_page.dart';
// import 'package:sticker_app/features/friend/provider/user_provider.dart';
// import 'package:star_sticker/presentation/provider/category_provider.dart';
// import 'package:star_sticker/presentation/provider/sticker_provider.dart';

import 'features/chat/widgets/chat_body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatBody(),
    );
  }
}

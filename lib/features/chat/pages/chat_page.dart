import 'package:flutter/material.dart';
import 'package:star_sticker/sticker.dart';
import 'package:sticker_app/features/chat/widgets/chat_appbar.dart';
import 'package:sticker_app/features/chat/widgets/chat_body.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.name, required this.imgUrl});

  final String name;
  final String imgUrl;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Calculator calculator;

  @override
  void initState() {
    super.initState();
    calculator = Calculator();
    print('Kết quả 5 + 4 = ${calculator.addOne(5 + 3)}');
  }

  @override
  Widget build(BuildContext buildContext) {
    return _buildUI(buildContext);
  }

  Widget _buildUI(BuildContext buildContext) {
    return Scaffold(appBar: chatAppBar(buildContext, widget.name, widget.imgUrl), body: const ChatBody());
  }
}

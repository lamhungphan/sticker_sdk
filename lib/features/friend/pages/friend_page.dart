import 'package:flutter/material.dart';
import 'package:sticker_app/features/friend/widgets/friend_appbar.dart';
import 'package:sticker_app/features/friend/widgets/friend_body.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
  }

  Widget _buildUI(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: friendAppBar(context),
      body: Padding(
        padding: EdgeInsets.only(
          left: screenSize * 0.03,
          right: screenSize * 0.03,
        ),
        child: const FriendBody(),
      ),
    );
  }
}

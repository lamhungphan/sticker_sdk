import 'package:flutter/material.dart';

PreferredSizeWidget? chatAppBar(
  BuildContext context,
  String userName,
  String imgUrl,
) {
  final double screenSize = MediaQuery.of(context).size.width;

  return AppBar(
    // Không tự động tạo nút leading
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize * 0.01),
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: screenSize * 0.02),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imgUrl),
          ),
        ),
        Expanded(
          child: Text(
            userName,
            // Tên dài quá thì hiện 3 chấm ở cuối
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    actions: [
      const Icon(Icons.phone),
      Padding(
        padding: EdgeInsets.only(
          right: screenSize * 0.03,
          left: screenSize * 0.02,
        ),
        child: const Icon(Icons.video_camera_back),
      ),
    ],
  );
}

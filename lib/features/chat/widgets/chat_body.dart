import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:sticker_app/features/chat/widgets/chat_list.dart';
import 'package:star_sticker/sticker.dart';
// import 'package:star_sticker/presentation/pages/sticker_page.dart';
// import 'package:star_sticker/presentation/provider/sticker_provider.dart';
// import 'package:star_sticker/models/sticker.dart';
import 'package:sticker_app/models/chat_content.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  // Dùng để loại bỏ tự động mở bàn phím
  final FocusNode _focusNode = FocusNode();
  // Lưu nội dung sticker vào chat
  List<ChatContent> chatContentList = [];
  // Lưu text chat
  TextEditingController textChat = TextEditingController();
  // Lưu các Sticker vừa dùng
  // List<Sticker> recentsStickerList = [];
  // // Lưu các thumb
  // List<Sticker> thumbList = [];

  @override
  void initState() {
    super.initState();
    // Gọi API khi widget khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Sticker.init();
      // Provider.of<StickerProvider>(context, listen: false).loadAllStickers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<StickerProvider>(context);

    // if (provider.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // if (provider.error != null) {
    //   return Center(child: Text('Error: ${provider.error}'));
    // }

    // if (provider.allSticker.isEmpty) {
    //   return const Center(child: Text('No stickers found'));
    // }

    // if (provider.thumb.isEmpty) {
    //   return const Center(child: Text('No thumb found'));
    // }

    // thumbList = provider.thumb;

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _chatContentList()),
          _buildBottomChatUI(context),
        ],
      ),
    );
  }

  Widget _chatContentList() {
    final double screenSize = MediaQuery.of(context).size.width;

    return ListView.builder(
      // rebuild khi độ dài chatContentList có thay đổi
      key: ValueKey(chatContentList.length),
      reverse: true,
      itemCount: chatContentList.length,
      itemBuilder: (BuildContext context, int index) {
        final ChatContent content = chatContentList[index];

        return Padding(
          padding: EdgeInsets.all(screenSize * 0.01),
          child: ChatList(
            content: content,
            onStickerSelected: (ChatContent newContent) {
              setState(() {
                chatContentList.insert(0, newContent);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomChatUI(BuildContext chatBodyContext) {
    final double screenSize = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(Icons.add_circle, size: 30),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize * 0.02,
                right: screenSize * 0.02,
              ),
              child: _textChatInputField(chatBodyContext),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (textChat.text.isNotEmpty) {
                setState(() {
                  chatContentList.insert(0, ChatContent(text: textChat.text));
                  textChat.clear();
                });
              }
            },
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _textChatInputField(BuildContext context) {
    return TextFormField(
      controller: textChat,
      focusNode: _focusNode,
      onTapOutside: (PointerDownEvent event) {
        // Tắt bàn phím khi ấn ra ngoài
        FocusScope.of(context).unfocus();
      },
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.04,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        hintText: 'Aa',
        suffixIcon: GestureDetector(
          onTap: () async {
            // Sử dụng Sticker SDK để hiển thị bottom sheet
            await Sticker.show(
              context,
              onStickerSelected: (String stickerUrl) {
                // Khi chọn sticker, thêm vào chat với URL sticker
                setState(() {
                  chatContentList.insert(
                    0,
                    ChatContent(stickerUrl: stickerUrl),
                  );
                });
                debugPrint('Sticker selected: $stickerUrl');
              },
            );

            // // Tránh tự động mở bàn phím
            // _focusNode.unfocus();

            // await showModalBottomSheet(
            //   // Không làm mờ đằng sau modal
            //   barrierColor: Colors.transparent,
            //   // Bo tròn góc
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(10),
            //       topRight: Radius.circular(10),
            //     ),
            //     // Độ dày viền
            //     side: BorderSide(width: 0.5),
            //   ),
            //   showDragHandle: true,
            //   isScrollControlled: true,
            //   context: context,
            //   builder: (BuildContext modalContext) {
            //     return Padding(
            //       padding: EdgeInsets.only(
            //         // Trả về chiều cao của phần bị che bởi bàn phím
            //         bottom: MediaQuery.of(modalContext).viewInsets.bottom,
            //       ),
            //       child: StatefulBuilder(
            //         builder: (
            //           BuildContext statefulBuilderContext,
            //           StateSetter modalSetState,
            //         ) {
            //           return DraggableScrollableSheet(
            //             // Khi mở cố định tại 40% màn hình
            //             initialChildSize: 0.4,
            //             // Kéo lên tối đa 80%
            //             maxChildSize: 0.8,
            //             // Kéo xuống tối đa 20%
            //             minChildSize: 0.2,
            //             expand: false,
            //             builder: (
            //               BuildContext context,
            //               ScrollController scrollController,
            //             ) {
            //               // return Padding(
            //               //   padding: EdgeInsets.only(left: screenSize * 0.03, right: screenSize * 0.03),
            //               //   child: StickerPage(
            //               //     modalSetState: modalSetState,
            //               //     scrollController: scrollController,
            //               //     thumbList: thumbList,
            //               //     recentsStickerList: recentsStickerList,
            //               //   ),
            //               // );
            //               return const SizedBox.shrink();
            //             },
            //           );
            //         },
            //       ),
            //     );
            //   },
            // );

            if (mounted) {
              // rebuild khi tắt modal
              setState(() {});
              // Tránh tự mở text field
              _focusNode.unfocus();
            }
          },
          child: const Icon(Icons.emoji_emotions, size: 30),
        ),
      ),
    );
  }
}

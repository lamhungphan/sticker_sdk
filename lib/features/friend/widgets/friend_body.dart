import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticker_app/features/chat/pages/chat_page.dart';
import 'package:sticker_app/features/friend/provider/user_provider.dart';
import 'package:sticker_app/models/user.dart';

class FriendBody extends StatefulWidget {
  const FriendBody({super.key});

  @override
  State<FriendBody> createState() => _FriendBodyState();
}

class _FriendBodyState extends State<FriendBody> {
  @override
  void initState() {
    super.initState();
    // Gọi API khi widget khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final double screenSize = MediaQuery.of(context).size.width;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    if (provider.users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: provider.users.length,
      itemBuilder: (BuildContext context, int index) {
        final User user = provider.users[index];

        return Padding(
          padding: EdgeInsets.only(bottom: screenSize * 0.04),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (BuildContext context) =>
                          ChatPage(name: user.name, imgUrl: user.avatar),
                ),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.avatar),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text('Last text'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

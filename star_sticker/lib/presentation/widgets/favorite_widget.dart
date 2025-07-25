import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: const Icon(Icons.favorite),
        onPressed: () {
          // Action for favorite button
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your Favorite Stickers')));
        },
      ),
    );
  }
}

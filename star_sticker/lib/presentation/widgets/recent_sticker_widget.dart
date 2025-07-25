import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecentStickerWidget extends StatefulWidget {
  RecentStickerWidget({
    super.key,
    required this.isRecentSelected,
    required this.modalSetState,
    required this.currentStickerType,
    required this.scrollController,
    required this.onStickerTypeChanged,
  });

  bool isRecentSelected;
  StateSetter modalSetState;
  String currentStickerType;
  ScrollController scrollController;
  Function(String) onStickerTypeChanged;

  @override
  State<RecentStickerWidget> createState() => _RecentStickerWidgetState();
}

class _RecentStickerWidgetState extends State<RecentStickerWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isRecentSelected = true;
        });
        widget.modalSetState(() {
          widget.onStickerTypeChanged('Recents');
          widget.scrollController.jumpTo(0);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color:
              widget.isRecentSelected
                  ? Colors.black.withAlpha(32)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.access_time),
      ),
    );
  }
}

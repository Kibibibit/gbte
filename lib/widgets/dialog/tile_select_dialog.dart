import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/dialog/fullscreen_dialog.dart';
import 'package:gbte/widgets/tile_display.dart';

class TileSelectDialog extends StatefulWidget {
  final bool multiSelect;

  const TileSelectDialog({super.key, required this.multiSelect});

  @override
  State<TileSelectDialog> createState() => _TileSelectDialogState();
}

class _TileSelectDialogState extends State<TileSelectDialog> {
  late List<int> selected;
  late ScrollController scrollController;

  int currentTile = 0;
  bool pointerDown = false;
  bool updated = false;

  final int tileWidth = 80;

  int tileIndex(int x, int y, int width) => (y * width) + x;

  void onDrag() {
    if (!updated) {
      setState(() {
        toggle();
        updated = true;
      });
    }
  }

  void onTap() {
    toggle();
  }

  void toggle() {
    setState(() {
      if (selected.contains(currentTile)) {
        selected.remove(currentTile);
      } else {
        selected.add(currentTile);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    selected = [];
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenDialog(
      title: "Select Tile${widget.multiSelect ? "s" : ""}",
      child: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          onTap: () => onTap(),
          onHorizontalDragUpdate: (_) => onDrag(),
          onVerticalDragUpdate: (_) => onDrag(),
          onVerticalDragEnd: (_) => setState(() {
            updated = false;
          }),
          onHorizontalDragEnd: (_) => setState(() {
            updated = false;
          }),
          child: GridView.count(
            controller: scrollController,
            crossAxisCount: (constraints.maxWidth / tileWidth).floor(),
            children: List.generate(
              Globals.tiles.length,
              (index) => MouseRegion(
                onEnter: (_) => setState(() {
                  currentTile = index;
                  updated = false;
                }),
                child: Stack(
                  children: [
                    TileDisplay(
                      tiles: [index],
                      metatileSize: 1,
                      primaryColor: 0,
                      secondaryColor: 0,
                      edit: false,
                      border: false,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: selected.contains(index)
                            ? const Color(0x330000FF)
                            : Colors.transparent,
                        border: Border.all(
                            color: selected.contains(index)
                                ? const Color(0xFF0000FF)
                                : Colors.transparent),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

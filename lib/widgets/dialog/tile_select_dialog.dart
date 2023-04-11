import 'dart:math';

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
  int startIndex = 0;

  final int tileWidth = 80;

  int tileIndex(int x, int y, int width) => (y * width) + x;

  int tileX(int index, int width) => index % width;
  int tileY(int index, int width) => (index / width).floor();

  void onTapDown() {
    setState(() {
      startIndex = currentTile;
    });
  }

  void onSecondaryTap() {
    setState(() {
      selected = [];
    });
  }

  void onDrag(int width) {
    setState(() {
      selected = [];

      if (widget.multiSelect) {
        int sx = tileX(startIndex, width);
        int sy = tileY(startIndex, width);

        int ex = tileX(currentTile, width);
        int ey = tileY(currentTile, width);

        int x0 = min(sx, ex);
        int x1 = max(sx, ex);
        int y0 = min(sy, ey);
        int y1 = max(sy, ey);

        for (int x = x0; x <= x1; x++) {
          for (int y = y0; y <= y1; y++) {
            selected.add(tileIndex(x, y, width));
          }
        }
      } else {
        toggle(currentTile);
      }
    });
  }

  void toggle(int index) {
    setState(() {
      if (selected.contains(index)) {
        selected.remove(index);
      } else {
        selected.add(index);
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
    return FullscreenDialog<List<int>>(
      title: "Select Tile${widget.multiSelect ? "s" : ""}",
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(selected),
            child: const Text("Select"))
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        int width = (constraints.maxWidth / tileWidth).floor();
        return GestureDetector(
          onHorizontalDragUpdate: (_) => onDrag(width),
          onVerticalDragUpdate: (_) => onDrag(width),
          onTapDown: (_) => onTapDown(),
          onTapUp: (_) => toggle(currentTile),
          onHorizontalDragStart: (_) => onTapDown(),
          onVerticalDragStart: (_) => onTapDown(),
          onSecondaryTap: () => onSecondaryTap(),
          child: GridView.count(
            controller: scrollController,
            crossAxisCount: width,
            children: List.generate(
              Globals.tiles.length,
              (index) => MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() {
                  currentTile = index;
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
                            : index == currentTile
                                ? const Color(0x110000FF)
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

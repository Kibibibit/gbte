import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/dialog/fullscreen_dialog.dart';
import 'package:gbte/widgets/tile_display.dart';

class TileSelectDialog extends StatefulWidget {
  const TileSelectDialog({super.key});

  @override
  State<TileSelectDialog> createState() => _TileSelectDialogState();
}

class _TileSelectDialogState extends State<TileSelectDialog> {
  late ScrollController scrollController;

  int currentTile = 0;

  final int tileWidth = 80;

  int tileIndex(int x, int y, int width) => (y * width) + x;

  int tileX(int index, int width) => index % width;
  int tileY(int index, int width) => (index / width).floor();

  void onTap() {
    Navigator.of(context).pop(currentTile);
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenDialog<int>(
      title: "Select Tiles",
      child: LayoutBuilder(builder: (context, constraints) {
        int width = (constraints.maxWidth / tileWidth).floor();
        return GestureDetector(
          onTap: onTap,
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
                        color: index == currentTile
                            ? const Color(0x110000FF)
                            : Colors.transparent,
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

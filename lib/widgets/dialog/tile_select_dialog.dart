import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/helpers/extensions/to_bytes.dart';
import 'package:gbte/widgets/dialog/fullscreen_dialog.dart';
import 'package:gbte/widgets/stroke_text.dart';
import 'package:gbte/widgets/tile_display.dart';

class TileSelectDialog extends StatefulWidget {
  final int tileBank;
  const TileSelectDialog({super.key, required this.tileBank});

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
    Navigator.of(context).pop(_indexFromBank(currentTile));
  }

  int _indexFromBank(int index) =>
      (widget.tileBank * Constants.tileBankSize) + index;

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
              Constants.tileBankSize,
              (index) => MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() {
                  currentTile = index;
                }),
                child: Stack(
                  children: [
                    TileDisplay(
                      tiles: [_indexFromBank(index)],
                      metatileSize: 1,
                      primaryColor: 0,
                      secondaryColor: 0,
                      edit: false,
                      border: false,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: index == currentTile
                            ? const Color(0x330000FF)
                            : Colors.transparent,
                      ),
                      child: Center(
                        child:
                            StrokeText(_indexFromBank(index).toByteString(1)),
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

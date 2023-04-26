import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/helpers/extensions/to_bytes.dart';
import 'package:gbte/widgets/dialog/fullscreen_dialog.dart';
import 'package:gbte/widgets/stroke_text.dart';
import 'package:gbte/widgets/tile_painter.dart';

class TileSelectDialog extends StatefulWidget {
  final int tileBank;
  const TileSelectDialog({super.key, required this.tileBank});

  @override
  State<TileSelectDialog> createState() => _TileSelectDialogState();
}

class _TileSelectDialogState extends State<TileSelectDialog> {
  int currentTile = 0;
  int scrollIndex = 0;

  int tileIndex(int x, int y) => (y * 16) + x;

  int tileX(int index) => index % 16;
  int tileY(int index) => (index / 16).floor();

  double posLeft(double tileWidth) {
    return tileX(currentTile) * tileWidth;
  }

  double posTop(double tileWidth) {
    return tileY(currentTile) * tileWidth;
  }

  void onTap() {}

  int _tileDisplaySize(int maxHeight) => maxHeight * 16;
  int _scrollOffset(int maxHeight) => scrollIndex * 16;

  int _indexFromBank(int index) =>
      (widget.tileBank * Constants.tileBankSize) + index;

  void onPointer(PointerEvent event, int maxHeight) {
    if (event is PointerScrollEvent) {
      int direction = (event.scrollDelta.dy.sign).toInt();
      if (scrollIndex == 0 && direction == -1) return;
      setState(() {
        scrollIndex += direction;

        int max = _scrollOffset(maxHeight) + _tileDisplaySize(maxHeight);
        if (max > 256) {
          scrollIndex--;
        }
      });
    } else if (event is PointerDownEvent) {
      if (event.buttons == 1) {
        Navigator.of(context)
            .pop(_indexFromBank(currentTile + _scrollOffset(maxHeight)));
      }
    }
  }

  void onHover(
      PointerEvent event, BoxConstraints constraints, double doubleHeight, int maxHeight) {
    int dx = ((event.localPosition.dx / constraints.maxWidth) * 16).floor();
    int dy = ((event.localPosition.dy / constraints.maxHeight) * doubleHeight)
        .floor();
    dy = min(dy, maxHeight-1);
    setState(() {
      currentTile = tileIndex(dx, dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenDialog<int>(
      title: "Select Tile",
      child: LayoutBuilder(builder: (context, constraints) {
        double tileWidth = constraints.maxWidth / 16;
        double doubleHeight =
            min((constraints.maxHeight / tileWidth), (256 / 16));
        int maxHeight = doubleHeight.floor();

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (event) => onHover(event, constraints, doubleHeight, maxHeight),
          child: Listener(
            onPointerSignal: (event) => onPointer(event, maxHeight),
            onPointerDown: (event) => onPointer(event, maxHeight),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size.infinite,
                  painter: TilePainter(
                      tiles: List.generate(_tileDisplaySize(maxHeight),
                          (i) => _indexFromBank(i) + _scrollOffset(maxHeight)),
                      tilesX: 16,
                      tilesY: maxHeight,
                      edit: false,
                      repaint: true,
                      border: false),
                ),
                GridView.count(
                  crossAxisCount: 16,
                  childAspectRatio: 1,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  children: List.generate(
                      _tileDisplaySize(maxHeight),
                      (index) => Center(
                            child: StrokeText((_scrollOffset(maxHeight) + index)
                                .toByteString(1)),
                          )),
                ),
                Positioned(
                  left: posLeft(tileWidth),
                  top: posTop(tileWidth),
                  child: SizedBox.square(
                    dimension: tileWidth,
                    child: Container(
                      color: const Color(0x330000FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

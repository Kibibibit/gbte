import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/palette.dart';
import 'package:gbte/models/tile.dart';

class TileDisplay extends StatefulWidget {
  final List<int> tiles;

  final int metatileSize;
  final int primaryColor;
  final int secondaryColor;

  final bool edit;

  const TileDisplay({
    super.key,
    required this.tiles,
    required this.metatileSize,
    required this.primaryColor,
    required this.secondaryColor,
    this.edit = false,
  });

  @override
  State<TileDisplay> createState() => _TileDisplayState();
}

class _TileDisplayState extends State<TileDisplay> {
  double _tileSize(double size) => size / (Tile.size * widget.metatileSize);

  bool repaint = false;

  late StreamSubscription<int> tileStream;

  @override
  void initState() {
    
    super.initState();
    tileStream = Events.tileEditStream.stream.listen((tile) {
      if (widget.tiles.contains(tile)) {
        setState(() {
          repaint = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    tileStream.cancel();
  }

  int _tilePos(double p, BuildContext context) =>
      (p / (_tileSize(context.size?.width ?? 0))).floor();

  void onEvent(PointerEvent event, BuildContext context) {
    if (!widget.edit) {
      return;
    }
    if ((context.size?.contains(event.localPosition)) ?? false) {
      int x = _tilePos(event.localPosition.dx, context);
      int y = _tilePos(event.localPosition.dy, context);

      int tileIndex = (y / Tile.size).floor() * widget.metatileSize +
          (x / Tile.size).floor();
      int sX = x % Tile.size;
      int sY = y % Tile.size;
      Globals.tiles[widget.tiles[tileIndex]].set(sX, sY,
          event.buttons == 1 ? widget.primaryColor : widget.secondaryColor);
      Events.updateTile(widget.tiles[tileIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            color: Colors.black,
            padding: const EdgeInsets.all(2),
            child: Listener(
              onPointerDown: (event) => onEvent(event, context),
              onPointerMove: (event) => onEvent(event, context),
              child: CustomPaint(
                painter: TilePainter(
                    edit: widget.edit,
                    tiles: widget.tiles,
                    metatileSize: widget.metatileSize,
                    repaint: repaint),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class TilePainter extends CustomPainter {
  final List<int> tiles;
  final int metatileSize;
  final bool edit;
  final bool repaint;

  TilePainter({
    required this.tiles,
    required this.metatileSize,
    required this.edit,
    required this.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint();
    double tileSize = size.height / metatileSize;

    int i = 0;
    for (int tileY = 0; tileY < metatileSize; tileY++) {
      for (int tileX = 0; tileX < metatileSize; tileX++) {
        paintTile(tileX * tileSize, tileY * tileSize, tiles[i],
            Globals.tilePalettes[tiles[i]], tileSize, painter, canvas, size);
        i++;
      }
    }
  }

  void paintTile(double drawX, double drawY, int tileIndex, int paletteIndex,
      double tileSize, Paint painter, Canvas canvas, Size size) {
    Tile tile = Globals.tiles[tileIndex];
    Palette palette = Globals.palettes[paletteIndex];
    double drawSize = tileSize / Tile.size;
    for (int x = 0; x < Tile.size; x++) {
      for (int y = 0; y < Tile.size; y++) {
        Rect rect = Rect.fromLTWH(
            drawX + (x * drawSize), drawY + (y * drawSize), drawSize, drawSize);
        painter.strokeWidth = 0.0;
        painter.color = palette.colors[tile.get(x, y)].toColor();
        painter.style = PaintingStyle.fill;
        canvas.drawRect(rect, painter);
        if (edit) {
          painter.style = PaintingStyle.stroke;
          painter.color = Colors.black;
          canvas.drawRect(rect, painter);
        }
      }
    }
    painter.strokeWidth = 3.0;
    painter.style = PaintingStyle.stroke;
    painter.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(drawX, drawY, tileSize, tileSize), painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => repaint;
}

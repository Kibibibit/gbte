import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/palette.dart';
import 'package:gbte/models/tile.dart';

class TileDisplay extends StatefulWidget {
  final List<int> tiles;
  final List<int> palettes;

  final int metatileSize;
  final int primaryColor;
  final int secondaryColor;

  const TileDisplay({
    super.key,
    required this.tiles,
    required this.metatileSize,
    required this.palettes,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<TileDisplay> createState() => _TileDisplayState();
}

class _TileDisplayState extends State<TileDisplay> {
  bool repaint = false;

  double _tileSize(double size) => size / (Tile.size * widget.metatileSize);

  int _tilePos(double p, BuildContext context) =>
      (p / (_tileSize(context.size?.width ?? 0))).floor();

  void onEvent(PointerEvent event, BuildContext context) {
    if ((context.size?.contains(event.localPosition)) ?? false) {
      int x = _tilePos(event.localPosition.dx, context);
      int y = _tilePos(event.localPosition.dy, context);

      int tileIndex = (y / Tile.size).floor() * widget.metatileSize +
          (x / Tile.size).floor();
      int sX = x % Tile.size;
      int sY = y % Tile.size;
      Globals.tiles[widget.tiles[tileIndex]].set(sX, sY,
          event.buttons == 1 ? widget.primaryColor : widget.secondaryColor);
      setState(() {
        repaint = true;
      });
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
                  tiles: widget.tiles,
                  metatileSize: widget.metatileSize,
                  palettes: widget.palettes,
                  repaint: repaint,
                ),
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
  final List<int> palettes;
  final int metatileSize;
  final bool repaint;

  TilePainter({
    required this.tiles,
    required this.metatileSize,
    required this.palettes,
    required this.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint();
    double tileSize = size.height / metatileSize;

    int i = 0;
    for (int tileY = 0; tileY < metatileSize; tileY++) {
      for (int tileX = 0; tileX < metatileSize; tileX++) {
        paintTile(tileX * tileSize, tileY * tileSize, tiles[i], palettes[i],
            tileSize, painter, canvas, size);
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

        painter.style = PaintingStyle.stroke;
        painter.color = Colors.black;
        canvas.drawRect(rect, painter);
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

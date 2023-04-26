import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/saveable/palette.dart';
import 'package:gbte/models/saveable/tile.dart';

class TilePainter extends CustomPainter {
  final List<int> tiles;
  final int tilesX;
  final int tilesY;
  final bool edit;
  final bool repaint;
  final bool border;
  TilePainter({
    required this.tiles,
    required this.tilesX,
    required this.tilesY,
    required this.edit,
    required this.repaint,
    required this.border,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint();
    double tileSize = size.width/tilesX;

    int i = 0;
    for (int tileY = 0; tileY < tilesY; tileY++) {
      for (int tileX = 0; tileX < tilesX; tileX++) {
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
    if (border) {
      painter.strokeWidth = 3.0;
      painter.style = PaintingStyle.stroke;
      painter.color = Colors.black;
      canvas.drawRect(Rect.fromLTWH(drawX, drawY, tileSize, tileSize), painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => repaint;
}

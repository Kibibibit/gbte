import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/saveable/palette.dart';
import 'package:gbte/models/saveable/tile.dart';
import 'package:gbte/models/app_event/tile_app_event.dart';

class TileDisplay extends StatefulWidget {
  final List<int> tiles;

  final int metatileSize;
  final int primaryColor;
  final int secondaryColor;

  final bool edit;
  final bool border;

  final Function(int index)? onHover;

  const TileDisplay({
    super.key,
    required this.tiles,
    required this.metatileSize,
    required this.primaryColor,
    required this.secondaryColor,
    this.edit = false,
    this.border = true, this.onHover,
  });

  @override
  State<TileDisplay> createState() => _TileDisplayState();
}

class _TileDisplayState extends State<TileDisplay> {
  double _tileSize(double size) => size / (Tile.size * widget.metatileSize);

  bool repaint = false;

  late StreamSubscription<int> tileStream;
  late StreamSubscription<String> loadStream;

  late List<String> previousTiles;

  @override
  void initState() {
    super.initState();
    _previousTiles();
    tileStream = Events.tileEditStream.stream.listen((tile) {
      if (widget.tiles.contains(tile)) {
        setState(() {
          repaint = true;
        });
      }
    });
    loadStream = Events.loadStream.stream.listen((_) {
      _previousTiles();
      setState(() {
        repaint = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    tileStream.cancel();
    loadStream.cancel();
  }

  List<String> _mapTiles() {
    return widget.tiles.map((e) => Globals.tiles[e].save()).toList();
  }

  void _previousTiles() {
    setState(() {
      previousTiles = _mapTiles();
    });
  }

  int _tilePos(double p, BuildContext context) =>
      (p / (_tileSize(context.size?.width ?? 0))).floor();

  int _tileIndex(double x, double y, BuildContext context) {
    int tx = _tilePos(x, context);
    int ty = _tilePos(y, context);
    return (ty / Tile.size).floor() * widget.metatileSize +
        (tx / Tile.size).floor();
  }

  void onPointerDown(PointerEvent event, BuildContext context) {
    if (!widget.edit) return;
    _previousTiles();
    onEvent(event, context);
  }

  void onPointerUp() {
    if (!widget.edit) return;
    List<String> newTiles = _mapTiles();
    TileAppEvent event = TileAppEvent(
        tileIndices: widget.tiles,
        previousTiles: previousTiles,
        nextTiles: newTiles);
    Events.appEvent(event);
  }

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

  void onHover(PointerEvent event, BuildContext context) {
    if (widget.onHover != null) {
      int tileIndex = _tileIndex(event.localPosition.dx, event.localPosition.dy, context);
      widget.onHover!(widget.tiles[tileIndex]);
      
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(widget.edit ? 2 : 0),
            child: MouseRegion(
              cursor:
                  widget.edit ? SystemMouseCursors.click : MouseCursor.defer,
              child: Listener(
                onPointerHover: (event) => onHover(event, context),
                onPointerDown: (event) => onPointerDown(event, context),
                onPointerMove: (event) => onEvent(event, context),
                onPointerUp: (_) => onPointerUp(),
                child: CustomPaint(
                  painter: TilePainter(
                      edit: widget.edit,
                      border: widget.border,
                      tiles: widget.tiles,
                      metatileSize: widget.metatileSize,
                      repaint: repaint),
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
  final int metatileSize;
  final bool edit;
  final bool repaint;
  final bool border;

  TilePainter({
    required this.tiles,
    required this.metatileSize,
    required this.edit,
    required this.repaint,
    required this.border,
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

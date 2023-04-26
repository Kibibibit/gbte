import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/helpers/extensions/to_bytes.dart';
import 'package:gbte/models/saveable/metatile.dart';
import 'package:gbte/widgets/dialog/tile_select_dialog.dart';
import 'package:gbte/widgets/stroke_text.dart';
import 'package:gbte/widgets/tile_display.dart';

class MetatileTileSelect extends StatefulWidget {
  final int metatileIndex;
  final int tileBank;
  final List<Metatile> metatiles;

  final void Function(int tile, int index) onChange;

  const MetatileTileSelect(
      {super.key,
      required this.metatileIndex,
      required this.onChange,
      required this.tileBank, required this.metatiles});

  @override
  State<MetatileTileSelect> createState() => _MetatileTileSelectState();
}

class _MetatileTileSelectState extends State<MetatileTileSelect> {
  Metatile get metatile => widget.metatiles[widget.metatileIndex];

  int? hoverTile;

  @override
  void initState() {
    super.initState();
    hoverTile = null;
  }

  void onClick(int index, BuildContext context) async {
    int tileIndex = await showDialog(
            context: context,
            builder: (context) => TileSelectDialog(
                  tileBank: widget.tileBank,
                )) ??
        metatile.tiles[index];
    widget.onChange(tileIndex, index);
  }

  void onHover(int index) {
    setState(() {
      hoverTile = index;
    });
  }

  void onExit(int index) {
    setState(() {
      hoverTile = null;
    });
  }

  int _index(int index) => (widget.tileBank*Constants.tileBankSize) + index;

  String label(int index) => index.toByteString(1);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.count(
          crossAxisCount: metatile.size,
          children: List.generate(
            metatile.size * metatile.size,
            (index) => MouseRegion(
              onHover: (_) => onHover(index),
              onExit: (_) => onExit(index),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onClick(index, context),
                child: Stack(
                  children: [
                    TileDisplay(
                        tiles: [_index(metatile.tiles[index])],
                        metatileSize: 1,
                        primaryColor: 0,
                        secondaryColor: 0),
                    Container(
                      color: index == hoverTile
                          ? const Color(0x330000FF)
                          : Colors.transparent,
                      child: Center(
                        child: StrokeText(
                         label(metatile.tiles[index]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

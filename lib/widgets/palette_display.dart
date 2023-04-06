import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';

class PaletteDisplay extends StatelessWidget {
  final int palette;

  const PaletteDisplay({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PaletteButton(palette: palette, index: 0),
        _PaletteButton(palette: palette, index: 1),
        _PaletteButton(palette: palette, index: 2),
        _PaletteButton(palette: palette, index: 3)
      ],
    );
  }
}

class _PaletteButton extends StatelessWidget {
  final int palette;
  final int index;

  const _PaletteButton({required this.palette, required this.index});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: Globals.palettes[palette].colors[index].toColor(),
        ),
      ),
    );
  }
}

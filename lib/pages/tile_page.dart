import 'package:flutter/material.dart';
import 'package:gbte/pages/base_page.dart';
import 'package:gbte/widgets/tile_display.dart';

class TilePage extends StatelessWidget {
  const TilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
        child: TileDisplay(
      tiles: [0],
      metatileSize: 1,
      palettes: [0],
      primaryColor: 2,
      secondaryColor: 0,
    ));
  }
}

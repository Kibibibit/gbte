import 'package:flutter/material.dart';
import 'package:gbte/pages/palette_page.dart';
import 'package:gbte/pages/root_page.dart';
import 'package:gbte/pages/tile_page.dart';
import 'package:gbte/widgets/palette_select.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const RootPage(
          pages: {
            "Sprite Tiles": TilePage(
              tileBank: 0,
              paletteBank: PaletteSelect.spriteBank,
            ),
            "Background Tiles": TilePage(
              tileBank: 2,
              paletteBank: PaletteSelect.backgroundBank,
            ),
            "Shared Tiles":
                TilePage(tileBank: 1, paletteBank: PaletteSelect.bothBanks),
            "Palettes": PalettePage(),
          },
        ));
  }
}

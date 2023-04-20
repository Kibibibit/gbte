import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/pages/metatile_page.dart';
import 'package:gbte/pages/root_page.dart';
import 'package:gbte/pages/tile_page.dart';

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
        home: RootPage(
          pages: {
            Constants.tilePage: const TilePage(),
            Constants.metaspritePage : MetatilePage(page: Constants.metaspritePage, metatiles: Globals.metasprites, isMetatiles: false,),
            Constants.metatilePage : MetatilePage(page: Constants.metatilePage, metatiles: Globals.metatiles, isMetatiles: true,),
          },
        ));
  }
}

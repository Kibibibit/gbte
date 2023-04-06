import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
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
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Globals.tiles[0].set(0, 0, 1);
    Globals.tiles[0].set(1, 0, 2);
    Globals.tiles[0].set(2, 0, 3);

    Uint8List save = Globals.tiles[0].save();

    Globals.tiles[1].load(save);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: TabBar(
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            controller: _tabController,
            tabs: const [
              Tab(
                height: 20,
                text: "Tiles",
              ),
              Tab(
                height: 20,
                text: "Metatiles",
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: TabBarView(
            controller: _tabController,
            children: const [TilePage(),TilePage()],
          ),
        );
      }),
    );
  }
}

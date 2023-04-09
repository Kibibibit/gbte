import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/fileio.dart';
import 'package:gbte/globals/globals.dart';

class RootPage extends StatefulWidget {
  final Map<String, Widget> pages;

  const RootPage({super.key, required this.pages});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String? filename;
  late StreamSubscription<String> _loadStreamSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.pages.length, vsync: this);
    _loadStreamSubscription = Events.loadStream.stream.listen((file) {
      setState(() {
        if (file.isEmpty) {
          filename = null;
        } else {
          filename = file;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loadStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filename ?? "Unsaved File"),
        leadingWidth: 250,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Globals.newFile(),
                icon: const Icon(Icons.add_box_rounded)),
            IconButton(
              onPressed: () => FileIO.saveFile(context),
              icon: const Icon(Icons.save),
            ),
            IconButton(
                onPressed: () => FileIO.saveAsFile(context),
                icon: const Icon(Icons.save_as)),
            IconButton(
              onPressed: () => FileIO.load(),
              icon: const Icon(Icons.open_in_new),
            ),
            IconButton(onPressed: ()=>Events.undoEvent(), icon: const Icon(Icons.undo)),
            IconButton(onPressed: ()=>Events.redoEvent(), icon: const Icon(Icons.redo)),
          ],
        ),
        toolbarHeight: 40,
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: TabBar(
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              controller: _tabController,
              tabs: widget.pages.keys
                  .map((tabTitle) => Tab(
                        height: 40,
                        child: Text(
                          tabTitle,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList()),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: TabBarView(
            controller: _tabController,
            children: widget.pages.values.toList(),
          ),
        );
      }),
    );
  }
}

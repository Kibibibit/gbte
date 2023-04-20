import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/fileio.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/shortcut_handler_widget.dart';
import 'package:gbte/widgets/tooltip_icon_button.dart';

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
        title: Text("${filename ?? 'Unsaved File'}${Globals.saved ? '' : '*'}"),
        actions: [
          TooltipIconButton(
              message: "New File (CTRL+N)",
              onPressed: () => FileIO.newFile(context),
              icon: const Icon(Icons.add_box_rounded)),
          TooltipIconButton(
              message: "Save (CTRL+S)",
              onPressed: () => FileIO.saveFile(context),
              icon: const Icon(Icons.save)),
          TooltipIconButton(
              message: "Save As (CTRL+SHIFT+S)",
              onPressed: () => FileIO.saveAsFile(context),
              icon: const Icon(Icons.save_as)),
          TooltipIconButton(
              message: "Load (CTRL+O)",
              onPressed: () => FileIO.load(context),
              icon: const Icon(Icons.open_in_new)),
          TooltipIconButton(
              message: "Export (CTRL+E)",
              onPressed: () => FileIO.exportFile(context),
              icon: const Icon(Icons.code)),
          TooltipIconButton(
              message: "Undo (CTRL+Z)",
              onPressed: () => Events.undoEvent(),
              icon: const Icon(Icons.undo)),
          TooltipIconButton(
              message: "Redo (CTRL+Y)",
              onPressed: () => Events.redoEvent(),
              icon: const Icon(Icons.redo)),
          TooltipIconButton(
            message: "Copy (CTRL+C)",
            onPressed: () => Events.copy(),
            icon: const Icon(Icons.copy),
          ),
          TooltipIconButton(
            message: "Cut (CTRL+X)",
            onPressed: () => Events.cut(),
            icon: const Icon(Icons.cut),
          ),
          TooltipIconButton(
            message: "Paste (CTRL+V)",
            onPressed: () => Events.paste(),
            icon: const Icon(Icons.paste),
          )
        ],
        toolbarHeight: 40,
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: TabBar(
              onTap: (value) =>
                  Globals.page = widget.pages.keys.toList()[value],
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
      body: ShortcutHandlerWidget(
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: TabBarView(
              controller: _tabController,
              children: widget.pages.values.toList(),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  final Map<String, Widget> pages;

  const RootPage({super.key, required this.pages});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.pages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        child: Text(tabTitle, style:const TextStyle(color: Colors.white),),
                        
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

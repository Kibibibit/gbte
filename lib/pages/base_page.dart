import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/globals/events.dart';

class BasePage extends StatefulWidget {
  final Widget child;

  final String page;
  final void Function()? onCopy;
  final void Function()? onCut;
  final void Function()? onPaste;

  const BasePage({super.key, required this.child, this.onCopy, this.onCut, this.onPaste, required this.page});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {

  late StreamSubscription<String> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = Events.copyCutPasteStream.stream.listen((event) {
      List<String> parts = event.split(";");
      if (parts[0] == widget.page) {

        if (parts[1] == Constants.cut && widget.onCut != null) {
          widget.onCut!();
        } else if (parts[1] == Constants.copy && widget.onCopy != null) {
          widget.onCopy!();
        } else if (parts[1] == Constants.paste && widget.onPaste != null) {
          widget.onPaste!();
        }

      } 
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: widget.child,
    );
  }
}

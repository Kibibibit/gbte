import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/fileio.dart';
import 'package:gbte/models/shortcuts/meta_key_activator.dart';

class ShortcutHandlerWidget extends StatelessWidget {
  final Widget? child;

  const ShortcutHandlerWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        MetaKeyActivator.control(LogicalKeyboardKey.keyN): () {
          FileIO.newFile(context);
        },
        MetaKeyActivator.control(LogicalKeyboardKey.keyS): () {
          FileIO.saveFile(context);
        },
        MetaKeyActivator.control(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.keyS): () {
          FileIO.saveAsFile(context);
        },
        MetaKeyActivator.control(LogicalKeyboardKey.keyO): () {
          FileIO.load(context);
        },
        MetaKeyActivator.control(LogicalKeyboardKey.keyZ): () {
          Events.undoEvent();
        },
        MetaKeyActivator.control(LogicalKeyboardKey.keyY): () {
          Events.redoEvent();
        },
        MetaKeyActivator.control(LogicalKeyboardKey.keyE): () {
          FileIO.exportFile(context);
        }
      },
      child: Focus(
        autofocus: true,
        child: child ?? Container(),
      ),
    );
  }
}

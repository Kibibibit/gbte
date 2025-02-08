import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbte/helpers/remove_null_elements.dart';

class MetaKeyActivator extends ShortcutActivator {
  final LogicalKeyboardKey metaKey;
  final LogicalKeyboardKey key1;
  final LogicalKeyboardKey? key2;
  final LogicalKeyboardKey? key3;

  late final List<LogicalKeyboardKey> _badMetaKeys;
  late final List<LogicalKeyboardKey> _goodKeys;

  MetaKeyActivator(this.metaKey, this.key1, [this.key2, this.key3]) {
    _init();
  }

  void _init() {
    _goodKeys = removeNullElements([metaKey, key1, key2, key3]);
    _badMetaKeys = _metaKeys
        .where((element) => element != metaKey && !_goodKeys.contains(element))
        .toList();
  }

  static final List<LogicalKeyboardKey> _metaKeys = [
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.metaLeft
  ];

  MetaKeyActivator.control(this.key1, [this.key2, this.key3])
      : metaKey = LogicalKeyboardKey.controlLeft {
    _init();
  }

  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) {
    return (_goodKeys.every(
            (element) => state.logicalKeysPressed.contains(event.logicalKey)) &&
        !_badMetaKeys.any(
            (element) => state.logicalKeysPressed.contains(event.logicalKey)));
  }

  @override
  String debugDescribeKeys() {
    String out = "${metaKey.debugName}+${key1.debugName}";
    if (key2 != null) {
      out = "$out+${key2!.debugName}";
    }
    if (key3 != null) {
      out = "$out+${key3!.debugName}";
    }
    return out;
  }

  @override
  Iterable<LogicalKeyboardKey>? get triggers => _goodKeys;
}

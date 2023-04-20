import 'package:flutter/material.dart';

class TooltipIconButton extends StatelessWidget {
  final String message;
  final void Function() onPressed;
  final Widget icon;
  final Duration? waitDuration;

  const TooltipIconButton({super.key, required this.message, required this.onPressed, required this.icon, this.waitDuration});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      showDuration: const Duration(seconds:0),
      message: message,
      waitDuration: waitDuration ?? const Duration(milliseconds: 200),
      child: IconButton(onPressed: onPressed, icon: icon),
    );
  }
}

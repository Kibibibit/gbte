import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbte/components/int_editing_controller.dart';

class IntField extends StatelessWidget {
  final IntEditingController controller;
  final Function(int value) onChange;
  final int previousValue;
  final InputDecoration? decoration;
  final bool enabled;

  const IntField(
      {super.key,
      required this.controller,
      required this.onChange,
      this.decoration,
      required this.previousValue,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: decoration,
      controller: controller,
      enabled: enabled,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        controller.text = value;
        onChange(controller.intValue);
      },
    );
  }
}

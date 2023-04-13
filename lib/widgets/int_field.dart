import 'package:flutter/material.dart';

class IntField extends StatelessWidget {
  final TextEditingController controller;
  final int min;
  final int max;
  final Function(int value) onChange;
  final int previousValue;
  final InputDecoration? decoration;

  const IntField(
      {super.key,
      required this.controller,
      required this.min,
      required this.max,
      required this.onChange,
      this.decoration,
      required this.previousValue});

  void doOnChange(String value) {
    while (value.startsWith("0")) {
      value = value.substring(1);
    }
    if (previousValue != 0 && value != "0") {
      value = value.replaceAll("0", "");
      controller.text = value;
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
    if (value.isEmpty) {
      value = min.toString();
      controller.text = min.toString();
    }
    int intVal = int.parse(value);
    if (intVal < min) {
      intVal = min;
      controller.text = min.toString();
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
    if (intVal > max) {
      intVal = max;
      controller.text = max.toString();
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
    onChange(intVal);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: decoration,
      controller: controller,
      onChanged: (value) => doOnChange(value),
    );
  }
}

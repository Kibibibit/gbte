import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {

  final int value;
  final void Function(int size) onChange;

  const SizeSelector({super.key, required this.value, required this.onChange});
  
  void change(int mult) {
    if (value + mult >= 2 && value + mult <= 4) onChange(value + mult);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: value > 2 ? () => change(-1) : null, icon:const Icon(Icons.chevron_left)),
        Text("$value x $value"),
        IconButton(onPressed: value < 4 ? () => change(1) : null, icon:const Icon(Icons.chevron_right)),
      ],
    );
  }
  
}
import 'package:flutter/material.dart';

class LabelledCheckbox extends StatelessWidget {
  final bool? value;
  final Function(bool?) onChanged;
  final String label;
  final bool enabled;

  const LabelledCheckbox({super.key, this.value, required this.onChanged, required this.label, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged:   enabled ? onChanged : null),
        const Padding(padding: EdgeInsets.only(left:10.0)),
        Text(label),
      ],
    );
  }
}

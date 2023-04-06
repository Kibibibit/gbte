import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';

class ColorSelect extends StatelessWidget {
  final void Function(int) onSelect;
  final int palette;
  final int selectedColor;

  const ColorSelect(
      {super.key,
      required this.onSelect,
      required this.palette,
      required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          4,
          (index) => AspectRatio(
                aspectRatio: 1,
                child: Material(
                  color: index == selectedColor ? Colors.grey : Colors.white,
                  child: InkWell(
                    onTap: () => onSelect(index),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color:
                              Globals.palettes[palette].colors[index].toColor(),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
    );
  }
}

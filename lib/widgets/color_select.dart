import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';

class ColorSelect extends StatelessWidget {
  final void Function(int) onSelectPrimary;
  final void Function(int)? onSelectSecondary;
  final int palette;
  final int selectedPrimaryColor;
  final int? selectedSecondaryColor;
  final bool secondarySelect;

  const ColorSelect({
    super.key,
    required this.onSelectPrimary,
    required this.palette,
    required this.selectedPrimaryColor,
    this.selectedSecondaryColor,
    this.onSelectSecondary,
    this.secondarySelect = false,
  }) : assert(
            (secondarySelect &&
                    selectedSecondaryColor != null &&
                    onSelectSecondary != null) ||
                !secondarySelect,
            "Must provide secondary colors and selectors if in secondary select mode");

  Widget colorDisplay(int color, {double maxHeight = double.infinity}) {
    Color c = Globals.palettes[palette].colors[color].toColor();

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            
            decoration: BoxDecoration(color: c, border: Border.all()),
          )),
    );
  }

  Widget colorDisplayDouble(int primaryColor, int secondaryColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          child: InkWell(
            onTap: () {
              int p = primaryColor;
              onSelectPrimary(secondaryColor);
              onSelectSecondary!(p);
            },
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Align(alignment: Alignment.bottomRight,child: colorDisplay(secondaryColor, maxHeight: constraints.maxHeight*0.8),),
                    Align(alignment: Alignment.topLeft,child: colorDisplay(primaryColor, maxHeight: constraints.maxHeight*0.8),)
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Padding(
         padding: const EdgeInsets.only(right:10.0),
         child: secondarySelect ? colorDisplayDouble(selectedPrimaryColor, selectedSecondaryColor!) : colorDisplay(selectedPrimaryColor),
       ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            4,
            (index) => AspectRatio(
              aspectRatio: 1,
              child: Container(
                color:
                    index == selectedPrimaryColor ? Colors.grey : Colors.white,
                child: GestureDetector(
                  onTap: () => onSelectPrimary(index),
                  onSecondaryTap: () {
                    if (secondarySelect) {
                      onSelectSecondary!(index);
                    }
                  },
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
            ),
          ),
        ),
      ],
    );
  }
}

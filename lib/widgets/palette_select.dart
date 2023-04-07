import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/constants/palette_bank.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/palette_display.dart';

class PaletteSelect extends StatelessWidget {
  final int selectedPalette;
  final int paletteBank;

  final void Function(int) onChange;

  void _onChange(int? p) {
    if (p != null) {
      onChange(p);
    }
  }

  const PaletteSelect(
      {super.key,
      required this.selectedPalette,
      required this.paletteBank,
      required this.onChange});

  DropdownMenuItem<int> paletteSelectItem(int value) => DropdownMenuItem(
        value: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: SizedBox(width: 50, child: Text(Globals.paletteNames[value])),
            ),
            PaletteDisplay(palette: value),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> items;

    if (paletteBank == PaletteBank.shared) {
      items = List.generate(Constants.paletteCount, (index) => paletteSelectItem(index));
    } else {
      items = List.generate(
          Constants.paletteBankSize, (index) => paletteSelectItem(index + (paletteBank * Constants.paletteBankSize)));
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton(
          items: items, onChanged: _onChange, value: selectedPalette),
    );
  }
}

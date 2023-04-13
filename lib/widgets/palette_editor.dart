import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/helpers/map_range.dart';
import 'package:gbte/models/saveable/gbc_color.dart';
import 'package:gbte/widgets/color_select.dart';
import 'package:gbte/widgets/palette_select.dart';

class PaletteEditor extends StatelessWidget {
  final void Function(int red) onChangeRed;
  final void Function(int green) onChangeGreen;
  final void Function(int blue) onChangeBlue;
  final int selectedPalette;
  final int selectedPrimaryColor;
  final int? selectedSecondaryColor;
  final void Function(int) onChangePrimaryColor;
  final void Function(int)? onChangeSecondaryColor;
  final bool secondarySelect;
  final int paletteBank;
  final void Function(int) onChangePalette;

  final void Function() onChangeStart;
  final void Function() onChangeEnd;

  final int red;
  final int green;
  final int blue;

  const PaletteEditor({
    super.key,
    required this.onChangeRed,
    required this.onChangeGreen,
    required this.onChangeBlue,
    required this.selectedPalette,
    required this.selectedPrimaryColor,
    this.selectedSecondaryColor,
    required this.onChangePrimaryColor,
    this.onChangeSecondaryColor,
    this.secondarySelect = false,
    required this.red,
    required this.green,
    required this.blue,
    required this.paletteBank,
    required this.onChangePalette,
    required this.onChangeStart,
    required this.onChangeEnd,
  });

  GBCColor getColor() {
    return Globals.palettes[selectedPalette].colors[selectedPrimaryColor];
  }

  Widget colorSlider({
    required String label,
    required void Function(int) onChange,
    required int value,
  }) {
    return Row(
      children: [
        SizedBox(width: 10, child: Text(label)),
        Slider(
          onChangeStart: (_) => onChangeStart(),
          onChangeEnd: (_) => onChangeEnd(),
          value: mapRangeToDouble(value, 0, 31, 0, 1),
          onChanged: (v) => onChange(
            mapRange(v, 0.0, 1.0, 0, 31),
          ),
        ),
        SizedBox(width: 20, child: Text("$value")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        colorSlider(label: "R", onChange: onChangeRed, value: red),
        colorSlider(label: "G", onChange: onChangeGreen, value: green),
        colorSlider(label: "B", onChange: onChangeBlue, value: blue),
        const Divider(),
        SizedBox(
          height: 50,
          child: ColorSelect(
            onSelectPrimary: onChangePrimaryColor,
            palette: selectedPalette,
            selectedPrimaryColor: selectedPrimaryColor,
            selectedSecondaryColor: selectedSecondaryColor,
            onSelectSecondary: onChangeSecondaryColor,
            secondarySelect: secondarySelect,
          ),
        ),
        const Divider(),
        PaletteSelect(
          selectedPalette: selectedPalette,
          paletteBank: paletteBank,
          onChange: onChangePalette,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gbte/constants/palette_bank.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/helpers/map_range.dart';
import 'package:gbte/pages/base_page.dart';
import 'package:gbte/widgets/color_select.dart';
import 'package:gbte/widgets/palette_select.dart';

class PalettePage extends StatefulWidget {
  const PalettePage({super.key});

  @override
  State<PalettePage> createState() => _PalettePageState();
}

class _PalettePageState extends State<PalettePage> {
  late int selectedPalette;
  late int selectedColor;

  late int red;
  late int green;
  late int blue;

  @override
  void initState() {
    super.initState();
    selectedPalette = 0;
    selectedColor = 0;
    loadColors();
  }

  void loadColors() {
    setState(() {
      red = Globals.palettes[selectedPalette].colors[selectedColor].r;
      green = Globals.palettes[selectedPalette].colors[selectedColor].g;
      blue = Globals.palettes[selectedPalette].colors[selectedColor].b;
    });
  }

  void onSelectPalette(int palette) {
    setState(() {
      selectedPalette = palette;
    });
    loadColors();
  }

  void onSelectColor(int color) {
    setState(() {
      selectedColor = color;
    });
    loadColors();
  }

  void onChangeRed(int r) {
    Globals.palettes[selectedPalette].colors[selectedColor].r = r;
    setState(() {
      red = r;
    });
  }

  void onChangeGreen(int g) {
    Globals.palettes[selectedPalette].colors[selectedColor].g = g;
    setState(() {
      green = g;
    });
  }

  void onChangeBlue(int b) {
    Globals.palettes[selectedPalette].colors[selectedColor].b = b;
    setState(() {
      blue = b;
    });
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
    return BasePage(
        child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                colorSlider(
                  label: "R",
                  onChange: onChangeRed,
                  value: red,
                ),
                colorSlider(
                  label: "G",
                  onChange: onChangeGreen,
                  value: green,
                ),
                colorSlider(
                  label: "B",
                  onChange: onChangeBlue,
                  value: blue,
                ),
              ],
            ),
            SizedBox(
              height: 50,
              child: ColorSelect(
                onSelect: onSelectColor,
                palette: selectedPalette,
                selectedColor: selectedColor,
              ),
            ),
          ],
        ),
        PaletteSelect(
          selectedPalette: selectedPalette,
          onChange: onSelectPalette,
          paletteBank: PaletteBank.shared,
        ),
      ],
    ));
  }
}

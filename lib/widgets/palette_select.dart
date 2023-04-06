import 'package:flutter/material.dart';
import 'package:gbte/widgets/palette_display.dart';

class PaletteSelect extends StatelessWidget {
  final int selectedPalette;
  final void Function(int) onSelect;
  final int paletteBank;

  static const int spriteBank = 0;
  static const int backgroundBank = 1;
  static const int bothBanks = 2;

  const PaletteSelect(
      {super.key,
      required this.selectedPalette,
      required this.onSelect,
      required this.paletteBank});

  int _index(int i) {
    if (paletteBank == bothBanks) {
      return i % 2 == 0 ? (i / 2).floor() : ((i - 1) / 2).floor() + 8;
    }
    return (8*paletteBank)+ i;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 4,
      crossAxisCount: paletteBank == bothBanks ? 2 : 1,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      children: List.generate(
        paletteBank == bothBanks ? 16 : 8,
        (index) => Material(
          color: selectedPalette == _index(index) ? Colors.grey : Colors.white,
          child: InkWell(
            onTap: () => onSelect(_index(index)),
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 20, child: Text('${_index(index)}')),
                    PaletteDisplay(palette: _index(index)),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

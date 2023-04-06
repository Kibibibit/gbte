import 'package:flutter/material.dart';
import 'package:gbte/widgets/palette_display.dart';

class PaletteSelect extends StatelessWidget {
  final int selectedPalette;
  final void Function(int) onSelect;

  const PaletteSelect(
      {super.key, required this.selectedPalette, required this.onSelect});

  int _index(int i) {
    return i%2==0 ? (i/2).floor() : ((i-1)/2).floor()+8;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 4,
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      children: List.generate(
        16,
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

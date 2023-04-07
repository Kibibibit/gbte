import 'package:flutter/material.dart';
import 'package:gbte/constants/palette_bank.dart';
import 'package:gbte/widgets/palette_display.dart';

class PaletteSelect extends StatelessWidget {

  final int selectedPalette;
  final int paletteBank;

  final void Function(int)  onChange;

  void _onChange(int? p) {
    if (p != null) {
      onChange(p);
    }
  }


  const PaletteSelect({super.key, required this.selectedPalette, required this.paletteBank, required this.onChange});

  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem<int>> items;

     if (paletteBank == PaletteBank.shared) {
      items = List.generate(16, (index) => DropdownMenuItem(value: index,child: PaletteDisplay(palette: index)));
    } else {
      items = List.generate(8, (index) =>DropdownMenuItem(value: index+(paletteBank*8),child: PaletteDisplay(palette: index+(paletteBank*8))));
    }
    
    return DropdownButtonHideUnderline(child: DropdownButton(items: items, onChanged: _onChange, value:selectedPalette));

  }



  
}
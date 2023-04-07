import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/constants/tile_bank.dart';
import 'package:gbte/widgets/tile_display.dart';

class TileSelect extends StatelessWidget {
  final void Function(int) onSelect;
  final int tileBank;
  final int selectedTile;
  final void Function(int?) onBankSelect;
  const TileSelect(
      {super.key,
      required this.onSelect,
      required this.selectedTile,
      required this.tileBank,
      required this.onBankSelect,
      
      });

  int _index(int i) => (tileBank * Constants.tileBankSize) + i;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<int>(
          items: const [
            DropdownMenuItem(
              value: TileBank.sprite,
              child: Text("Sprite"),
            ),
            DropdownMenuItem(
              value: TileBank.background,
              child: Text("Background"),
            ),
            DropdownMenuItem(
              value: TileBank.shared,
              child: Text("Shared"),
            )
          ],
          value: tileBank,
          onChanged: onBankSelect,
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: Constants.tileBankSize,
            itemBuilder: (context, index) => Material(
              color: selectedTile == _index(index)
                  ? Colors.lightBlue
                  : Colors.transparent,
              child: InkWell(
                onTap: () => onSelect(_index(index)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(
                          "${_index(index)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TileDisplay(
                        tiles: [_index(index)],
                        metatileSize: 1,
                        primaryColor: 2,
                        secondaryColor: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

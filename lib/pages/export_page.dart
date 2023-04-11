import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/dialog/tile_select_dialog.dart';
import 'package:gbte/widgets/labelled_checkbox.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {


  late bool exportToOneFile;
  late bool tilesInOneFile;
  late bool palettesInOneFile;
  
  @override
  void initState() {
    super.initState();
    loadState();
    

  }

  void loadState() {
    setState(() {
      exportToOneFile = Globals.exportFlags[Globals.exportToOneFile]!;
      tilesInOneFile = Globals.exportFlags[Globals.tilesInOneFile]!;
      palettesInOneFile = Globals.exportFlags[Globals.palettesInOneFile]!;
    });
  }

  void onFlagChange(String key, bool? value) {
    if (value != null) {
      Globals.exportFlags[key] = value;
      loadState();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelledCheckbox(label: "Export as one File", value: exportToOneFile, onChanged: (v) => onFlagChange(Globals.exportToOneFile,v)),
            LabelledCheckbox(label: "Export tiles in one file", value: tilesInOneFile, onChanged: (v) => onFlagChange(Globals.tilesInOneFile,v), enabled: !exportToOneFile),
            LabelledCheckbox(label: "Export palettes in one file", value: palettesInOneFile, onChanged: (v) => onFlagChange(Globals.palettesInOneFile,v), enabled: !exportToOneFile),
            TextButton(onPressed: () => showDialog(context: context, builder: (context)=>const TileSelectDialog(multiSelect: false)), child: const Text("dialog"))
          ],
        )
      ],
    );
  }

  
}
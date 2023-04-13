import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/dialog/fullscreen_dialog.dart';
import 'package:gbte/widgets/int_field.dart';
import 'package:gbte/widgets/labelled_checkbox.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({super.key});

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  late bool exportToOneFile;
  late bool tilesInOneFile;
  late bool palettesInOneFile;

  late int exportSpriteTiles;
  late int exportSharedTiles;
  late int exportBackgroundTiles;

  late TextEditingController exportSpriteTilesController;

  @override
  void initState() {
    super.initState();
    loadState();
    exportSpriteTilesController =
        TextEditingController(text: exportSpriteTiles.toString());
  }

  void loadState() {
    setState(() {
      exportToOneFile = Globals.exportFlags[Globals.exportToOneFile]!;
      tilesInOneFile = Globals.exportFlags[Globals.tilesInOneFile]!;
      palettesInOneFile = Globals.exportFlags[Globals.palettesInOneFile]!;
      exportSpriteTiles = Globals.exportRanges[Globals.exportSpriteTiles]!;
      exportSharedTiles = Globals.exportRanges[Globals.exportSharedTiles]!;
      exportBackgroundTiles =
          Globals.exportRanges[Globals.exportBackgroundTiles]!;
    });
  }

  void onFlagChange(String key, bool? value) {
    if (value != null) {
      Globals.exportFlags[key] = value;
      loadState();
    }
  }

  void onIntChange(String key, int value) {
    Globals.exportRanges[key] = value;
    loadState();
  }

  Widget textField(
      {required String labelText,
      required String key,
      required TextEditingController controller,
      required Function(String, String, TextEditingController) onChanged,
      List<TextInputFormatter>? inputFormatters}) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        inputFormatters: inputFormatters,
        onChanged: (value) => onChanged(key, value, controller),
        decoration: InputDecoration(labelText: labelText),
      ),
    );
  }

  Widget numberField(
      {required String labelText,
      required String key,
      required TextEditingController controller,
      required int min,
      required int max,
      required void Function(int) onChange}) {
    return SizedBox(
        width: 200,
        child: IntField(
          controller: controller,
          min: min,
          max: max,
          onChange: onChange,
          previousValue: Globals.exportRanges[key] ?? 0,
          decoration: InputDecoration(labelText: labelText),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenDialog(
      title: "Export",
      actions: [TextButton(onPressed: () => {}, child: const Text("Export"))],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelledCheckbox(
                  label: "Export as one File",
                  value: exportToOneFile,
                  onChanged: (v) => onFlagChange(Globals.exportToOneFile, v)),
              LabelledCheckbox(
                  label: "Export tiles in one file",
                  value: tilesInOneFile,
                  onChanged: (v) => onFlagChange(Globals.tilesInOneFile, v),
                  enabled: !exportToOneFile),
              LabelledCheckbox(
                  label: "Export palettes in one file",
                  value: palettesInOneFile,
                  onChanged: (v) => onFlagChange(Globals.palettesInOneFile, v),
                  enabled: !exportToOneFile),
              const Divider(),
              numberField(
                  labelText: "Sprite tiles to export",
                  key: Globals.exportSpriteTiles,
                  min: 0,
                  max: 255,
                  onChange: (value) =>
                      onIntChange(Globals.exportSpriteTiles, value),
                  controller: exportSpriteTilesController),
            ],
          )
        ],
      ),
    );
  }
}

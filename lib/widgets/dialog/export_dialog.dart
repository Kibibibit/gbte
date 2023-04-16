import 'package:flutter/material.dart';
import 'package:gbte/components/int_editing_controller.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/dialog/fullscreen_dialog.dart';
import 'package:gbte/widgets/file_field.dart';
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
  late bool exportSprites;
  late bool exportShared;
  late bool exportBackground;
  late bool exportPalettesSprite;
  late bool exportPalettesBackground;

  late int exportSpriteTileIndex;
  late int exportSharedTileIndex;
  late int exportBackgroundTileIndex;
  late int exportSpritePaletteIndex;
  late int exportBackgroundPaletteIndex;

  late String exportOneFileLocation;
  late String exportTilesLocation;
  late String exportPalettesLocation;
  late String exportSpriteTilesLocation;
  late String exportSharedTilesLocation;
  late String exportBackgroundTilesLocation;
  late String exportSpritePalettesLocation;
  late String exportBackgroundPalettesLocation;

  late IntEditingController exportSpriteTilesController;
  late IntEditingController exportSharedTilesController;
  late IntEditingController exportBackgroundTilesController;
  late IntEditingController exportSpritePalettesController;
  late IntEditingController exportBackgroundPalettesController;

  @override
  void initState() {
    super.initState();
    loadState();
    exportSpriteTilesController = IntEditingController(
        max: 255,
        intValue: Globals.exportRanges[Globals.exportSpriteTileIndex]!);
    exportSharedTilesController = IntEditingController(
        max: 255,
        intValue: Globals.exportRanges[Globals.exportSharedTileIndex]!);
    exportBackgroundTilesController = IntEditingController(
        max: 255,
        intValue: Globals.exportRanges[Globals.exportBackgroundTileIndex]!);
    exportSpritePalettesController = IntEditingController(
        max: 7,
        intValue: Globals.exportRanges[Globals.exportSpritePaletteIndex]!);
    exportBackgroundPalettesController = IntEditingController(
        max: 7,
        intValue: Globals.exportRanges[Globals.exportBackgroundPaletteIndex]!);
  }

  void loadState() {
    setState(() {
      exportToOneFile = Globals.exportFlags[Globals.exportToOneFile]!;
      tilesInOneFile = Globals.exportFlags[Globals.tilesInOneFile]!;
      palettesInOneFile = Globals.exportFlags[Globals.palettesInOneFile]!;
      exportSprites = Globals.exportFlags[Globals.exportSprites]!;
      exportShared = Globals.exportFlags[Globals.exportShared]!;
      exportBackground = Globals.exportFlags[Globals.exportBackground]!;
      exportPalettesSprite = Globals.exportFlags[Globals.exportPalettesSprite]!;
      exportPalettesBackground =
          Globals.exportFlags[Globals.exportPalettesBackground]!;
      exportSpriteTileIndex =
          Globals.exportRanges[Globals.exportSpriteTileIndex]!;
      exportSharedTileIndex =
          Globals.exportRanges[Globals.exportSharedTileIndex]!;
      exportBackgroundTileIndex =
          Globals.exportRanges[Globals.exportBackgroundTileIndex]!;
      exportSpritePaletteIndex =
          Globals.exportRanges[Globals.exportSpritePaletteIndex]!;
      exportBackgroundPaletteIndex =
          Globals.exportRanges[Globals.exportBackgroundPaletteIndex]!;

      exportOneFileLocation =
          Globals.exportStrings[Globals.exportOneFileLocation]!;
      exportTilesLocation = Globals.exportStrings[Globals.exportTilesLocation]!;
      exportPalettesLocation =
          Globals.exportStrings[Globals.exportPalettesLocation]!;
      exportSpriteTilesLocation =
          Globals.exportStrings[Globals.exportSpriteTilesLocation]!;
      exportSharedTilesLocation =
          Globals.exportStrings[Globals.exportSharedTilesLocation]!;
      exportBackgroundTilesLocation =
          Globals.exportStrings[Globals.exportBackgroundTilesLocation]!;
      exportSpritePalettesLocation =
          Globals.exportStrings[Globals.exportSpritePalettesLocation]!;
      exportBackgroundPalettesLocation =
          Globals.exportStrings[Globals.exportBackgroundPalettesLocation]!;
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

  void onFileChange(String key, String value) {
    Globals.exportStrings[key] = value;
    loadState();
  }

  Widget numberField(
      {required String labelText,
      required String key,
      required IntEditingController controller,
      required int min,
      required int max,
      required void Function(int) onChange,
      bool enabled = true}) {
    return SizedBox(
        width: 200,
        child: IntField(
          controller: controller,
          onChange: onChange,
          previousValue: Globals.exportRanges[key] ?? 0,
          decoration: InputDecoration(labelText: labelText),
          enabled: enabled,
        ));
  }

  Widget fileField(
      {required String labelText,
      required String key,
      required String value,
      required void Function(String) onChange,
      bool enabled = true}) {
    return FileField(
      path: value,
      onChange: onChange,
      label: Text(labelText),
      enabled: enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenDialog(
      title: "Export",
      actions: [TextButton(onPressed: () => {Navigator.of(context).pop(true)}, child: const Text("Export"))],
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
            ],
          ),
          const Padding(padding: EdgeInsets.all(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelledCheckbox(
                label: "Export Sprite Tiles",
                value: exportSprites,
                onChanged: (v) => onFlagChange(Globals.exportSprites, v),
              ),
              numberField(
                labelText: "Export sprite tiles up to:",
                key: Globals.exportSpriteTileIndex,
                min: 0,
                max: 255,
                onChange: (value) =>
                    onIntChange(Globals.exportSpriteTileIndex, value),
                controller: exportSpriteTilesController,
                enabled: exportSprites,
              ),
              LabelledCheckbox(
                label: "Export Shared Tiles",
                value: exportShared,
                onChanged: (v) => onFlagChange(Globals.exportShared, v),
              ),
              numberField(
                labelText: "Export shared tiles up to:",
                key: Globals.exportSharedTileIndex,
                min: 0,
                max: 255,
                onChange: (value) =>
                    onIntChange(Globals.exportSharedTileIndex, value),
                controller: exportSharedTilesController,
                enabled: exportShared,
              ),
              LabelledCheckbox(
                label: "Export Background Tiles",
                value: exportBackground,
                onChanged: (v) => onFlagChange(Globals.exportBackground, v),
              ),
              numberField(
                  labelText: "Export background tiles up to:",
                  key: Globals.exportSharedTileIndex,
                  min: 0,
                  max: 255,
                  onChange: (value) =>
                      onIntChange(Globals.exportBackgroundTileIndex, value),
                  controller: exportBackgroundTilesController,
                  enabled: exportBackground),
              LabelledCheckbox(
                label: "Export Sprite Palettes",
                value: exportPalettesSprite,
                onChanged: (v) => onFlagChange(Globals.exportPalettesSprite, v),
              ),
              numberField(
                labelText: "Export sprite palettes up to:",
                key: Globals.exportSpritePaletteIndex,
                controller: exportSpritePalettesController,
                min: 0,
                max: 7,
                onChange: (value) =>
                    onIntChange(Globals.exportSpritePaletteIndex, value),
                enabled: exportPalettesSprite,
              ),
              LabelledCheckbox(
                label: "Export Background Palettes",
                value: exportPalettesBackground,
                onChanged: (v) =>
                    onFlagChange(Globals.exportPalettesBackground, v),
              ),
              numberField(
                labelText: "Export background palettes up to:",
                key: Globals.exportBackgroundPaletteIndex,
                controller: exportBackgroundPalettesController,
                min: 0,
                max: 7,
                onChange: (value) =>
                    onIntChange(Globals.exportBackgroundPaletteIndex, value),
                enabled: exportPalettesBackground,
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fileField(
                labelText: "Export All Location",
                key: Globals.exportOneFileLocation,
                value: exportOneFileLocation,
                onChange: (v) => onFileChange(Globals.exportOneFileLocation, v),
                enabled: exportToOneFile,
              ),
              const Divider(),
              fileField(
                labelText: "Export tiles location",
                key: Globals.exportTilesLocation,
                value: exportTilesLocation,
                onChange: (v) => onFileChange(Globals.exportTilesLocation, v),
                enabled: !exportToOneFile && tilesInOneFile,
              ),
              fileField(
                labelText: "Export palettes location",
                key: Globals.exportPalettesLocation,
                value: exportPalettesLocation,
                onChange: (v) => onFileChange(Globals.exportPalettesLocation, v),
                enabled: !exportToOneFile && palettesInOneFile,
              ),
              const Divider(),
              fileField(
                labelText: "Export sprite tiles location",
                key: Globals.exportSpriteTilesLocation,
                value: exportSpriteTilesLocation,
                onChange: (v) => onFileChange(Globals.exportSpriteTilesLocation, v),
                enabled: !exportToOneFile && !tilesInOneFile,
              ),
              fileField(
                labelText: "Export shared tiles location",
                key: Globals.exportSharedTilesLocation,
                value: exportSharedTilesLocation,
                onChange: (v) => onFileChange(Globals.exportSharedTilesLocation, v),
                enabled: !exportToOneFile && !tilesInOneFile,
              ),
              fileField(
                labelText: "Export background tiles location",
                key: Globals.exportBackgroundTilesLocation,
                value: exportBackgroundTilesLocation,
                onChange: (v) => onFileChange(Globals.exportBackgroundTilesLocation, v),
                enabled: !exportToOneFile && !tilesInOneFile,
              ),
              const Divider(),
              fileField(
                labelText: "Export sprite palettes location",
                key: Globals.exportSpritePalettesLocation,
                value: exportSpritePalettesLocation,
                onChange: (v) => onFileChange(Globals.exportSpritePalettesLocation, v),
                enabled: !exportToOneFile && !palettesInOneFile,
              ),
              fileField(
                labelText: "Export background palettes location",
                key: Globals.exportBackgroundPalettesLocation,
                value: exportBackgroundPalettesLocation,
                onChange: (v) => onFileChange(Globals.exportBackgroundPalettesLocation, v),
                enabled: !exportToOneFile && !palettesInOneFile,
              ),
            ],
          )
        ],
      ),
    );
  }
}

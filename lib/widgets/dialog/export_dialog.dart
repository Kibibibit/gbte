import 'package:flutter/material.dart';
import 'package:gbte/components/int_editing_controller.dart';
import 'package:gbte/globals/exports.dart';
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
        intValue: Exports.exportRanges[Exports.exportSpriteTileIndex]!);
    exportSharedTilesController = IntEditingController(
        max: 255,
        intValue: Exports.exportRanges[Exports.exportSharedTileIndex]!);
    exportBackgroundTilesController = IntEditingController(
        max: 255,
        intValue: Exports.exportRanges[Exports.exportBackgroundTileIndex]!);
    exportSpritePalettesController = IntEditingController(
        max: 7,
        intValue: Exports.exportRanges[Exports.exportSpritePaletteIndex]!);
    exportBackgroundPalettesController = IntEditingController(
        max: 7,
        intValue: Exports.exportRanges[Exports.exportBackgroundPaletteIndex]!);
  }

  void loadState() {
    setState(() {
      exportToOneFile = Exports.exportFlags[Exports.exportToOneFile]!;
      tilesInOneFile = Exports.exportFlags[Exports.tilesInOneFile]!;
      palettesInOneFile = Exports.exportFlags[Exports.palettesInOneFile]!;
      exportSprites = Exports.exportFlags[Exports.exportSprites]!;
      exportShared = Exports.exportFlags[Exports.exportShared]!;
      exportBackground = Exports.exportFlags[Exports.exportBackground]!;
      exportPalettesSprite = Exports.exportFlags[Exports.exportPalettesSprite]!;
      exportPalettesBackground =
          Exports.exportFlags[Exports.exportPalettesBackground]!;
      exportSpriteTileIndex =
          Exports.exportRanges[Exports.exportSpriteTileIndex]!;
      exportSharedTileIndex =
          Exports.exportRanges[Exports.exportSharedTileIndex]!;
      exportBackgroundTileIndex =
          Exports.exportRanges[Exports.exportBackgroundTileIndex]!;
      exportSpritePaletteIndex =
          Exports.exportRanges[Exports.exportSpritePaletteIndex]!;
      exportBackgroundPaletteIndex =
          Exports.exportRanges[Exports.exportBackgroundPaletteIndex]!;

      exportOneFileLocation =
          Exports.exportStrings[Exports.exportOneFileLocation]!;
      exportTilesLocation = Exports.exportStrings[Exports.exportTilesLocation]!;
      exportPalettesLocation =
          Exports.exportStrings[Exports.exportPalettesLocation]!;
      exportSpriteTilesLocation =
          Exports.exportStrings[Exports.exportSpriteTilesLocation]!;
      exportSharedTilesLocation =
          Exports.exportStrings[Exports.exportSharedTilesLocation]!;
      exportBackgroundTilesLocation =
          Exports.exportStrings[Exports.exportBackgroundTilesLocation]!;
      exportSpritePalettesLocation =
          Exports.exportStrings[Exports.exportSpritePalettesLocation]!;
      exportBackgroundPalettesLocation =
          Exports.exportStrings[Exports.exportBackgroundPalettesLocation]!;
    });
  }

  void onFlagChange(String key, bool? value) {
    if (value != null) {
      Exports.exportFlags[key] = value;
      loadState();
    }
  }

  void onIntChange(String key, int value) {
    Exports.exportRanges[key] = value;
    loadState();
  }

  void onFileChange(String key, String value) {
    Exports.exportStrings[key] = value;
    loadState();
  }

  bool enableExportButton() {
    List<bool> values = [];

    if (Exports.exportFlags.values.every((element) => !element)) return false;

    if (exportToOneFile) {
      values.add(exportOneFileLocation.isNotEmpty);
    } else {
      if (tilesInOneFile) {
        values.add(exportTilesLocation.isNotEmpty);
      } else {
        if (exportSprites) {
          values.add(exportSpriteTilesLocation.isNotEmpty);
        }
        if (exportShared) {
          values.add(exportSharedTilesLocation.isNotEmpty);
        }
        if (exportBackground) {
          values.add(exportBackgroundTilesLocation.isNotEmpty);
        }
      }
      if (palettesInOneFile) {
        values.add(exportPalettesLocation.isNotEmpty);
      } else {
        if (exportPalettesSprite) {
          values.add(exportSpritePalettesLocation.isNotEmpty);
        }
        if (exportPalettesBackground) {
          values.add(exportBackgroundPalettesLocation.isNotEmpty);
        }
      }
    }

    return values.every((element) => element);
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
          previousValue: Exports.exportRanges[key] ?? 0,
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
      actions: [
        TextButton(
            onPressed: enableExportButton()
                ? () => Navigator.of(context).pop(true)
                : null,
            child: const Text("Export"))
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelledCheckbox(
                  label: "Export as one File",
                  value: exportToOneFile,
                  onChanged: (v) => onFlagChange(Exports.exportToOneFile, v)),
              LabelledCheckbox(
                  label: "Export tiles in one file",
                  value: tilesInOneFile,
                  onChanged: (v) => onFlagChange(Exports.tilesInOneFile, v),
                  enabled: !exportToOneFile),
              LabelledCheckbox(
                  label: "Export palettes in one file",
                  value: palettesInOneFile,
                  onChanged: (v) => onFlagChange(Exports.palettesInOneFile, v),
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
                onChanged: (v) => onFlagChange(Exports.exportSprites, v),
              ),
              numberField(
                labelText: "Export sprite tiles up to:",
                key: Exports.exportSpriteTileIndex,
                min: 0,
                max: 255,
                onChange: (value) =>
                    onIntChange(Exports.exportSpriteTileIndex, value),
                controller: exportSpriteTilesController,
                enabled: exportSprites,
              ),
              LabelledCheckbox(
                label: "Export Shared Tiles",
                value: exportShared,
                onChanged: (v) => onFlagChange(Exports.exportShared, v),
              ),
              numberField(
                labelText: "Export shared tiles up to:",
                key: Exports.exportSharedTileIndex,
                min: 0,
                max: 255,
                onChange: (value) =>
                    onIntChange(Exports.exportSharedTileIndex, value),
                controller: exportSharedTilesController,
                enabled: exportShared,
              ),
              LabelledCheckbox(
                label: "Export Background Tiles",
                value: exportBackground,
                onChanged: (v) => onFlagChange(Exports.exportBackground, v),
              ),
              numberField(
                  labelText: "Export background tiles up to:",
                  key: Exports.exportSharedTileIndex,
                  min: 0,
                  max: 255,
                  onChange: (value) =>
                      onIntChange(Exports.exportBackgroundTileIndex, value),
                  controller: exportBackgroundTilesController,
                  enabled: exportBackground),
              LabelledCheckbox(
                label: "Export Sprite Palettes",
                value: exportPalettesSprite,
                onChanged: (v) => onFlagChange(Exports.exportPalettesSprite, v),
              ),
              numberField(
                labelText: "Export sprite palettes up to:",
                key: Exports.exportSpritePaletteIndex,
                controller: exportSpritePalettesController,
                min: 0,
                max: 7,
                onChange: (value) =>
                    onIntChange(Exports.exportSpritePaletteIndex, value),
                enabled: exportPalettesSprite,
              ),
              LabelledCheckbox(
                label: "Export Background Palettes",
                value: exportPalettesBackground,
                onChanged: (v) =>
                    onFlagChange(Exports.exportPalettesBackground, v),
              ),
              numberField(
                labelText: "Export background palettes up to:",
                key: Exports.exportBackgroundPaletteIndex,
                controller: exportBackgroundPalettesController,
                min: 0,
                max: 7,
                onChange: (value) =>
                    onIntChange(Exports.exportBackgroundPaletteIndex, value),
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
                key: Exports.exportOneFileLocation,
                value: exportOneFileLocation,
                onChange: (v) => onFileChange(Exports.exportOneFileLocation, v),
                enabled: exportToOneFile,
              ),
              const Divider(),
              fileField(
                labelText: "Export tiles location",
                key: Exports.exportTilesLocation,
                value: exportTilesLocation,
                onChange: (v) => onFileChange(Exports.exportTilesLocation, v),
                enabled: !exportToOneFile && tilesInOneFile,
              ),
              fileField(
                labelText: "Export palettes location",
                key: Exports.exportPalettesLocation,
                value: exportPalettesLocation,
                onChange: (v) =>
                    onFileChange(Exports.exportPalettesLocation, v),
                enabled: !exportToOneFile && palettesInOneFile,
              ),
              const Divider(),
              fileField(
                labelText: "Export sprite tiles location",
                key: Exports.exportSpriteTilesLocation,
                value: exportSpriteTilesLocation,
                onChange: (v) =>
                    onFileChange(Exports.exportSpriteTilesLocation, v),
                enabled: !exportToOneFile && !tilesInOneFile && exportSprites,
              ),
              fileField(
                labelText: "Export shared tiles location",
                key: Exports.exportSharedTilesLocation,
                value: exportSharedTilesLocation,
                onChange: (v) =>
                    onFileChange(Exports.exportSharedTilesLocation, v),
                enabled: !exportToOneFile && !tilesInOneFile && exportShared,
              ),
              fileField(
                labelText: "Export background tiles location",
                key: Exports.exportBackgroundTilesLocation,
                value: exportBackgroundTilesLocation,
                onChange: (v) =>
                    onFileChange(Exports.exportBackgroundTilesLocation, v),
                enabled:
                    !exportToOneFile && !tilesInOneFile && exportBackground,
              ),
              const Divider(),
              fileField(
                labelText: "Export sprite palettes location",
                key: Exports.exportSpritePalettesLocation,
                value: exportSpritePalettesLocation,
                onChange: (v) =>
                    onFileChange(Exports.exportSpritePalettesLocation, v),
                enabled: !exportToOneFile &&
                    !palettesInOneFile &&
                    exportPalettesSprite,
              ),
              fileField(
                labelText: "Export background palettes location",
                key: Exports.exportBackgroundPalettesLocation,
                value: exportBackgroundPalettesLocation,
                onChange: (v) =>
                    onFileChange(Exports.exportBackgroundPalettesLocation, v),
                enabled: !exportToOneFile &&
                    !palettesInOneFile &&
                    exportPalettesBackground,
              ),
            ],
          )
        ],
      ),
    );
  }
}

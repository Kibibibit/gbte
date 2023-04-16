import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/constants/tile_bank.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/helpers/filename_from_path.dart';
import 'package:gbte/helpers/int_to_bytes.dart';
import 'package:gbte/helpers/string_to_bytes.dart';
import 'package:gbte/models/saveable/palette.dart';
import 'package:gbte/models/saveable/saveable.dart';
import 'package:gbte/models/saveable/tile.dart';
import 'package:gbte/widgets/dialog/export_dialog.dart';
import 'package:gbte/widgets/dialog/file_deleted_dialog.dart';
import 'package:gbte/widgets/dialog/overwrite_file_dialog.dart';
import 'package:gbte/widgets/dialog/unsaved_changes_dialog.dart';

abstract class FileIO {
  static const List<String> _types = ["gbt"];

  static const int _maxWidth = 40;

  static String _loadString(List<int> data) {
    List<int> sizeBytes = data.getRange(0, 4).toList();
    data.removeRange(0, 4);
    int size = bytesToInt(sizeBytes);
    List<int> units = data.getRange(0, size).toList();
    data.removeRange(0, size);
    return utf8.decode(units);
  }

  static void _save(File saveLocation) async {
    if (saveLocation.existsSync()) {
      saveLocation.deleteSync();
    }
    saveLocation.createSync();
    saveLocation.writeAsBytesSync(createSaveData(saveLocation));
    Globals.saved = true;
  }

  static Future<File?> _getSaveAsLocation() async {
    String? path = await FilePicker.platform.saveFile(
      dialogTitle: "Save as?",
      allowedExtensions: _types,
      type: FileType.custom,
    );
    if (path != null) {
      if (!path.endsWith(".gbt")) {
        path = '$path.gbt';
      }
      return File(path);
    }
    return null;
  }

  static void saveAsFile(BuildContext context) async {
    File? saveLocation = await FileIO._getSaveAsLocation();
    if (saveLocation == null) return;
    bool canSave = false;
    if (saveLocation.existsSync()) {
      if (context.mounted) {
        canSave = await showDialog<bool>(
                context: context,
                builder: (context) => const OverwriteFileDialog()) ??
            false;
      }
    } else {
      canSave = true;
    }

    if (canSave) {
      FileIO._save(saveLocation);
      FileIO.triggerLoadStream(saveLocation);
      Globals.saveLocation = saveLocation;
    }
  }

  static void saveFile(BuildContext context) async {
    if (Globals.saveLocation != null) {
      if (Globals.saveLocation!.existsSync()) {
        FileIO._save(Globals.saveLocation!);
        FileIO.triggerLoadStream(Globals.saveLocation!);
      } else {
        bool canSave = false;
        if (context.mounted) {
          canSave = await showDialog<bool>(
                  context: context,
                  builder: (context) => const FileDeletedDialog()) ??
              false;
        }
        if (canSave) {
          if (context.mounted) {
            FileIO._save(Globals.saveLocation!);
            FileIO.triggerLoadStream(Globals.saveLocation!);
          }
        }
      }
    } else {
      saveAsFile(context);
    }
  }

  static void triggerLoadStream(File file) {
    String path = fileNameFromPath(file.path);
    Events.load(path);
  }

  static void load(BuildContext context) async {
    if (!Globals.saved) {
      if (context.mounted) {
        bool cont = await showDialog(
                context: context,
                builder: (context) => const UnsavedChangesDialog()) ??
            false;
        if (!cont) {
          return;
        }
      }
    }

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(dialogTitle: "Load", allowedExtensions: _types);
    if (result != null) {
      File file = File(result.files.single.path!);
      if (file.existsSync()) {
        Globals.saveLocation = file;
        List<int> data = file.readAsBytesSync().toList();

        for (String key in Globals.exportFlags.keys) {
          int flag = data.removeAt(0);
          Globals.exportFlags[key] = flag > 0;
        }

        for (String key in Globals.exportRanges.keys) {
          int value = data.removeAt(0);
          Globals.exportRanges[key] = value;
        }

        for (String key in Globals.exportStrings.keys) {
          String value = _loadString(data);
          Globals.exportStrings[key] = value;
        }

        List<int> object = [];
        int objectSize = 0;
        int paletteCount = 0;
        int tileCount = 0;
        for (int d in data) {
          if (object.length != objectSize) {
            object.add(d);
          } else {
            if (object.isNotEmpty) {
              if (objectSize == Saveable.tileByteLength) {
                Globals.tiles[tileCount].load(Uint8List.fromList(object));
                tileCount++;
              }
              if (objectSize == Saveable.paletteByteLength) {
                Globals.palettes[paletteCount].load(Uint8List.fromList(object));
                paletteCount++;
              }
              object = [];
            }
            if (Saveable.dataHeaders.contains(d)) {
              objectSize = Saveable.dataSizes[d];
              object.add(d);
            }
          }
        }
        Globals.saved = true;
        Events.clearAppEventQueue();
        triggerLoadStream(file);
      }
    }
  }

  static List<int> createSaveData(File saveLocation) {
    List<int> out = [];

    for (bool value in Globals.exportFlags.values) {
      out.add(value ? 0x01 : 0x00);
    }

    for (int value in Globals.exportRanges.values) {
      out.add(value);
    }

    for (String string in Globals.exportStrings.values) {
      out.addAll(stringToBytes(string));
    }

    for (Palette palette in Globals.palettes) {
      out.addAll(palette.save().toList());
    }
    for (Tile tile in Globals.tiles) {
      out.addAll(tile.save().toList());
    }

    return out;
  }

  static Future<void> exportFile(BuildContext context) async {
    bool doExport = false;
    if (context.mounted) {
      doExport = await showDialog(
          context: context, builder: (context) => const ExportDialog());
    } else {
      return;
    }
    if (!doExport) return;
    if (Globals.exportFlags[Globals.exportToOneFile]!) {
      _exportFile(
        Globals.exportStrings[Globals.exportOneFileLocation]!,
        spriteTiles: true,
        sharedTiles: true,
        backgroundTiles: true,
        spritePalettes: true,
        backgroundPalettes: true,
      );
    }
  }

  static void _exportFile(
    String path, {
    bool spriteTiles = false,
    bool sharedTiles = false,
    bool backgroundTiles = false,
    bool spritePalettes = false,
    bool backgroundPalettes = false,
  }) {
    File cFile = File(path);
    File hFile = File(path.replaceAll(".c", ".h"));

    if (cFile.existsSync()) {
      cFile.deleteSync();
    }
    cFile.createSync();
    if (hFile.existsSync()) {
      hFile.deleteSync();
    }
    hFile.createSync();

    List<String> cLines = _fileHeader(path, false);
    List<String> hLines = [
      "#ifndef _${fileNameFromPath(path).toUpperCase()}_H",
      "#define _${fileNameFromPath(path).toUpperCase()}_H"
    ];
    hLines.addAll(_fileHeader(path, true));
    hLines.add("");
    cLines.add("#include \"${fileNameFromPath(path)}.h\"");
    cLines.add("");

    if (spriteTiles) {
      hLines.add("extern const unsigned char sprite_tiles[];");
      cLines.addAll(_exportTiles(TileBank.sprite, "sprite_tiles"));
    }

    hLines.add("#endif");

    for (String line in cLines) {
      cFile.writeAsStringSync("$line\n",mode:FileMode.append);
    }
    for (String line in hLines) {
      hFile.writeAsStringSync("$line\n",mode:FileMode.append);
    }


  }

  static List<String> _fileHeader(String path, bool h) {
    List<String> out = [];
    out.add("/// ${fileNameFromPath(path)}.${h ? "h" : "c"}");
    out.add("/// Auto-generated file by gbte");
    out.add("/// Generated on ${DateTime.now().toLocal().toIso8601String()}");
    out.add("");
    return out;
  }

  static List<String> _exportTiles(int tileBank, String varName) {
    List<String> out = ["const unsigned char $varName[] = {"];

    late String key;
    late int offset;

    if (tileBank == TileBank.sprite) {
      key = Globals.exportSpriteTileIndex;
      offset = 0;
    } else if (tileBank == TileBank.shared) {
      key = Globals.exportSharedTileIndex;
      offset = Constants.tileBankSize;
    } else {
      key = Globals.exportBackgroundPaletteIndex;
      offset = Constants.tileBankSize * 2;
    }

    int count = Globals.exportRanges[key]! + 1 + offset;

    List<Tile> tiles = Globals.tiles.sublist(offset, count);
    List<int> data = [];

    for (Tile tile in tiles) {
      data.addAll(tile.export().toList());
    }

    String row = "";
    while (data.isNotEmpty) {
      if (row.isEmpty) {
        row = "    ";
      }
      int byte = data.removeAt(0);
      String byteString =
          "0x${byte.toRadixString(16).toUpperCase().padLeft(2, '0')}";
      if (data.isNotEmpty) {
        byteString = "$byteString,";
      }
      row = "$row$byteString";
      if (row.length > _maxWidth) {
        out.add(row);
        row = "";
      }
    }
    if (row.replaceAll(" ","").isNotEmpty) out.add(row);
    
    out.add("};");
    return out;
  }
}

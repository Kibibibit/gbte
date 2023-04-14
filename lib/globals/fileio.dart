import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/helpers/int_to_bytes.dart';
import 'package:gbte/helpers/string_to_bytes.dart';
import 'package:gbte/models/saveable/palette.dart';
import 'package:gbte/models/saveable/saveable.dart';
import 'package:gbte/models/saveable/tile.dart';
import 'package:gbte/widgets/dialog/export_dialog.dart';
import 'package:gbte/widgets/dialog/file_deleted_dialog.dart';
import 'package:gbte/widgets/dialog/overwrite_file_dialog.dart';

abstract class FileIO {
  static const List<String> _types = ["gbt"];

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
    String path = file.path.replaceAll("\\", "/");
    RegExp reg = RegExp(r"[/](.*).gbt");
    path = reg.firstMatch(path)?.group(1) ?? "";
    path = path.split("/").last;
    Events.load(path);
  }

  static void load() async {
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
      out.add(value ? 0x01: 0x00);
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

    if (context.mounted) {
      await showDialog(context: context, builder: (context) => const ExportDialog());
    }


  }


}

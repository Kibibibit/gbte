import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/palette.dart';
import 'package:gbte/models/saveable.dart';
import 'package:gbte/models/tile.dart';

abstract class FileIO {
  static const List<String> _types = ["gbt"];

  static void save() async {
    if (Globals.saveLocation != null) {
      if (Globals.saveLocation!.existsSync()) {
        Globals.saveLocation!.deleteSync();
        Globals.saveLocation!.createSync();
        Globals.saveLocation!.writeAsBytesSync(createSaveData());
      } else {
        saveAs();
      }
    } else {
      saveAs();
    }
  }

  static void saveAs() async {
    String? path = await FilePicker.platform.saveFile(
      dialogTitle: "Save as?",
      allowedExtensions: _types,
      type: FileType.custom,
    );
    if (path != null) {
      if (!path.endsWith(".gbt")) {
        path = '$path.gbt';
      }
      File file = File(path);
      if (file.existsSync()) {
        print("Overwriting!");
      }
      file.createSync();
      file.writeAsBytes(createSaveData());
      Globals.saveLocation = file;
    }
  }

  static void load() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(dialogTitle: "Load", allowedExtensions: _types);
    if (result != null) {
      File file = File(result.files.single.path!);
      if (file.existsSync()) {
        List<int> data = file.readAsBytesSync().toList();
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
        String path = file.path.replaceAll("\\", "/");
        RegExp reg = RegExp(r"[/](.*).gbt");
        path = reg.firstMatch(path)?.group(1) ?? "";
        path = path.split("/").last;
        Events.load(path);
      }
    }
  }

  static List<int> createSaveData() {
    List<int> out = [];
    for (Palette palette in Globals.palettes) {
      out.addAll(palette.save().toList());
    }
    for (Tile tile in Globals.tiles) {
      out.addAll(tile.save().toList());
    }

    return out;
  }
}

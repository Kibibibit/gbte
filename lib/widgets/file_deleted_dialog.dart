import 'package:flutter/material.dart';
import 'package:gbte/widgets/yes_no_dialog.dart';

class FileDeletedDialog extends StatelessWidget {
  const FileDeletedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const YesNoDialog(
        title: Text("File Deleted!"),
        body: [Text("The file at this location is missing, recreate it?")]);
  }
}

import 'package:flutter/material.dart';
import 'package:gbte/widgets/dialog/yes_no_dialog.dart';

class OverwriteFileDialog extends StatelessWidget {
  const OverwriteFileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const YesNoDialog(title: Text("Overwrite File?"), body: [
      Text("The file here already exists, overwrite it?"),
    ]);
  }
}

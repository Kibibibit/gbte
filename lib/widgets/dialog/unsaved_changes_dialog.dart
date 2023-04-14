import 'package:flutter/material.dart';
import 'package:gbte/widgets/dialog/yes_no_dialog.dart';

class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const YesNoDialog(title: Text("Unsaved Changes!"), body: [Text("You have unsaved changes! Do you want to discard them?")]);
  }



}
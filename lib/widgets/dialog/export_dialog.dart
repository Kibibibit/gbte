import 'package:flutter/material.dart';
import 'package:gbte/pages/export_page.dart';
import 'package:gbte/widgets/dialog/fullscreen_dialog.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});


  @override
  Widget build(BuildContext context) {

    return const FullscreenDialog(title: "Export File", child: ExportPage());

  }
}

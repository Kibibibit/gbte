import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileField extends StatelessWidget {
  final String path;
  final Widget? label;
  final void Function(String) onChange;
  final bool enabled;

  const FileField(
      {super.key,
      required this.path,
      required this.onChange,
      this.label,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        label ?? Container(),
        TextButton.icon(
          onPressed: !enabled
              ? null
              : () async {
                  String? result = await FilePicker.platform.saveFile(
                    dialogTitle: "Select File",
                    allowedExtensions: ["c"],
                    type: FileType.custom,
                  );
                  String out = "";
                  if (result != null) {
                    out = result;
                  }
                  onChange(out);
                },
          icon: const Icon(Icons.folder),
          label: Text(path.isEmpty ? "Select File" : path),
        ),
      ],
    );
  }
}

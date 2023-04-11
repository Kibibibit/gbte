import 'package:flutter/material.dart';
import 'package:gbte/pages/export_page.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            constraints: BoxConstraints(
              minWidth: (constraints.maxWidth) * 0.75,
              minHeight: (constraints.maxHeight) * 0.75,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Export File", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                const Expanded(child: ExportPage())
              ],
            ),
          );
        }
      ),
    );
  }
}

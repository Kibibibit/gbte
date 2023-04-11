import 'package:flutter/material.dart';

class FullscreenDialog<T> extends StatelessWidget {

  final String title;
  final T Function()? onClose;
  final Widget child;
  const FullscreenDialog({super.key, required this.title, this.onClose, required this.child});

  void doOnClose(BuildContext context) {
    if (onClose != null) {
      T output = onClose!();
      Navigator.of(context).pop(output);
    } else {
      Navigator.of(context).pop();
    }
  }

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
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 36),),
                    IconButton(onPressed: () => doOnClose(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                Expanded(child: child)
              ],
            ),
          );
        }
      ),
    );
  }
  
}
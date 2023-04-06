import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: child,
    );
  }
}

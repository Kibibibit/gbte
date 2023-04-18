import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;

  final Color strokeColor;
  final Color fillColor;

  const StrokeText(this.text,
      {super.key,
      this.strokeColor = Colors.black,
      this.fillColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = strokeColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: fillColor
          )
        )
      ],
    );
  }
}

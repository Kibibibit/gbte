import 'package:flutter/material.dart';

class IntEditingController extends TextEditingController {

  late final int _min;
  late final int _max;
  late int intValue;

  IntEditingController({this.intValue = 0, int min = 0, required int max}) {
    _min = min;
    _max = max;
    text=intValue.toString();
  }

  int get min => _min;
  int get max => _max;


  @override
  set text(String newValue) {

    while (text.startsWith("0") && text != "0") {
      value = value.copyWith(text:text.substring(1));
    }
    if (newValue.isEmpty) {
      newValue = min.toString();
      value= value.copyWith(text: min.toString());
    }
    int intVal = int.parse(newValue);
    if (intVal < min) {
      value= value.copyWith(text: min.toString());
      intVal = min;
    }
    if (intVal > max) {
      value = value.copyWith(text: max.toString());
      intVal = max;
    }
    intValue = intVal;
    value = value.copyWith(text:intValue.toString());
    selection = TextSelection.collapsed(offset: text.length);
    
  }




}
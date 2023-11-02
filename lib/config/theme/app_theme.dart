import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent
];

class AppTheme {
  final int selectedColor;
  final bool isDarkMode;

  const AppTheme({this.selectedColor = 0, this.isDarkMode = false})
      : assert(selectedColor >= 0, 'selectedColor must be less than 0'),
        assert(selectedColor < colorList.length,
            'selectedColor must be less than colorList.length');

  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      // brightness: isDarkMode ? Brightness.dark : Brightness.light,
      brightness: Brightness.light,
      // colorSchemeSeed: colorList[selectedColor],
      colorSchemeSeed: Colors.blue,
      appBarTheme: const AppBarTheme(centerTitle: false));

  AppTheme copyWith({int? selectedColor, bool? isDarkMode}) => AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode);
}
